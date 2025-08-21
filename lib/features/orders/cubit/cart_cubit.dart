import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';
import '../models/cart_item_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  void addItem(Map<String, dynamic> product) {
    final existingIndex = state.items.indexWhere(
      (item) => item.productId == product['id'],
    );

    if (existingIndex >= 0) {
      final updatedItems = List<CartItemModel>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      _updateState(updatedItems);
    } else {
      final newItem = CartItemModel(
        productId: product['id'],
        productName: product['name_en'] ?? 'Unknown',
        price: (product['price'] ?? 0.0).toDouble(),
        imageUrl: product['image_url'] ?? '',
        quantity: 1,
      );
      final updatedItems = List<CartItemModel>.from(state.items)..add(newItem);
      _updateState(updatedItems);
    }
  }

  void removeItem(String productId) {
    final updatedItems = state.items
        .where((item) => item.productId != productId)
        .toList();
    _updateState(updatedItems);
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();
    _updateState(updatedItems);
  }

  void clearCart() {
    emit(CartState.initial());
  }

  void _updateState(List<CartItemModel> items) {
    final totalAmount = items.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final itemCount = items.fold(0, (sum, item) => sum + item.quantity);

    emit(
      state.copyWith(
        items: items,
        totalAmount: totalAmount,
        itemCount: itemCount,
      ),
    );
  }
}
