class CartItemModel {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;
  final int quantity;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  CartItemModel copyWith({
    String? productId,
    String? productName,
    double? price,
    String? imageUrl,
    int? quantity,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;

  Map<String, dynamic> toOrderItem() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'name_en': productName,
    };
  }
}
