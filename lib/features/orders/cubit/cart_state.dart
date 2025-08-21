import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';

class CartState {
  final List<CartItemModel> items;
  final double totalAmount;
  final int itemCount;

  const CartState({
    required this.items,
    required this.totalAmount,
    required this.itemCount,
  });

  factory CartState.initial() {
    return const CartState(
      items: [],
      totalAmount: 0.0,
      itemCount: 0,
    );
  }

  CartState copyWith({
    List<CartItemModel>? items,
    double? totalAmount,
    int? itemCount,
  }) {
    return CartState(
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartState &&
        listEquals(other.items, items) &&
        other.totalAmount == totalAmount &&
        other.itemCount == itemCount;
  }

  @override
  int get hashCode => items.hashCode ^ totalAmount.hashCode ^ itemCount.hashCode;
}
