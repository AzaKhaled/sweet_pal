import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

class OrderState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? error;

  const OrderState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class OrderCubit extends Cubit<OrderState> {
  final OrderService _orderService;

  OrderCubit(this._orderService) : super(const OrderState());

  Future<void> loadOrders() async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final ordersData = await _orderService.getUserOrders();
      final orders = ordersData.map((orderData) => OrderModel.fromJson(orderData)).toList();
      emit(state.copyWith(orders: orders, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

 Future<String> createOrder({
  required List<Map<String, dynamic>> items,
  required double totalPrice,
}) async {
  emit(state.copyWith(isLoading: true, error: null));
  
  try {
    final updatedItems = items.map((item) {
      return {
        'product_id': item['product_id'],
        'product_name': item['product_name'], 
        'quantity': item['quantity'],
        'price': item['price'],
      };
    }).toList();

    final order = await _orderService.createOrder(
      items: updatedItems,
      totalPrice: totalPrice,
    );

    // بعد إنشاء الطلب، إعادة التحميل
    await loadOrders();
    
    return order['id'] as String;
  } catch (e) {
    emit(state.copyWith(error: e.toString(), isLoading: false));
    rethrow;
  }
}

  Future<void> updateOrderStatus(String orderId, String status) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      debugPrint('Updating order $orderId status to: $status');
      
      // Update in database
      await _orderService.updateOrderStatus(orderId, status);
      
      // Update local state
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          debugPrint('Order $orderId status updated locally to: $status');
          return order.copyWith(status: status);
        }
        return order;
      }).toList();
      
      emit(state.copyWith(orders: updatedOrders, isLoading: false));
      
      // Log success
      debugPrint('Order status updated successfully for order: $orderId');
      
    } catch (e) {
      debugPrint('Error updating order status: $e');
      emit(state.copyWith(error: 'Failed to update order status: ${e.toString()}', isLoading: false));
      rethrow;
    }
  }

  Future<void> refreshOrder(String orderId) async {
    try {
      debugPrint('Refreshing order: $orderId');
      
      // Get the latest order data from the server
      final orderData = await _orderService.getOrder(orderId);
      final updatedOrder = OrderModel.fromJson(orderData);
      
      // Update the order in the local state
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return updatedOrder;
        }
        return order;
      }).toList();
      
      emit(state.copyWith(orders: updatedOrders));
      
      debugPrint('Order refreshed successfully: $orderId');
      
    } catch (e) {
      debugPrint('Error refreshing order: $e');
      // Don't emit error state for refresh, just log it
    }
  }
}
