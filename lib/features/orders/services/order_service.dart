import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/errors/exceptions.dart';

class OrderService {
  final SupabaseClient _client = Supabase.instance.client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  Future<Map<String, dynamic>> createOrder({
    required double totalPrice,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      if (_currentUserId == null) {
        throw CustomException(message: 'User not authenticated');
      }

      final order = await _client.from('orders').insert({
        'user_id': _currentUserId,
        'total_price': totalPrice,
        'status': 'pending',
      }).select().single();

      final orderItems = items.map((item) => {
        'order_id': order['id'],
        'product_id': item['product_id'],
        'quantity': item['quantity'],
        'price': item['price'],
      }).toList();

      await _client.from('order_items').insert(orderItems);

      return order;
    } catch (e) {
      throw CustomException(message: 'Failed to create order: \${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserOrders() async {
    try {
      if (_currentUserId == null) {
        throw CustomException(message: 'User not authenticated');
      }

      final orders = await _client
          .from('orders')
          .select('*, order_items(*, products(*))')
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(orders);
    } catch (e) {
      throw CustomException(message: 'Failed to fetch orders: \${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getOrder(String orderId) async {
    try {
      if (_currentUserId == null) {
        throw CustomException(message: 'User not authenticated');
      }

      final order = await _client
          .from('orders')
          .select('*, order_items(*, products(*))')
          .eq('id', orderId)
          .eq('user_id', _currentUserId!)
          .single();

      return order;
    } catch (e) {
      throw CustomException(message: 'Failed to fetch order: \${e.toString()}');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      if (_currentUserId == null) {
        throw CustomException(message: 'User not authenticated');
      }

      await _client
          .from('orders')
          .update({'status': status})
          .eq('id', orderId)
          .eq('user_id', _currentUserId!);
    } catch (e) {
      throw CustomException(message: 'Failed to update order: \${e.toString()}');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, 'cancelled');
  }
}
