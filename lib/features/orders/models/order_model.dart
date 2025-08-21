class OrderModel {
  final String id;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle the nested structure from Supabase
    List<Map<String, dynamic>> items = [];
    
    if (json['order_items'] != null) {
      for (var item in json['order_items']) {
        Map<String, dynamic> processedItem = {
          'product_id': item['product_id'] ?? '',
          'quantity': item['quantity'] ?? 0,
          'price': (item['price'] ?? 0.0).toDouble(),
          'product_name': _extractProductName(item),
          'image_url': _extractProductImage(item),
        };
        
        items.add(processedItem);
      }
    } else if (json['items'] != null) {
      items = List<Map<String, dynamic>>.from(json['items']);
      // Ensure all items have proper product names
      items = items.map((item) {
        return {
          ...item,
          'product_name': _extractProductName(item),
          'image_url': _extractProductImage(item),
        };
      }).toList();
    }

    return OrderModel(
      id: json['id'] ?? '',
      items: items,
      totalAmount: (json['total_price'] ?? 0.0).toDouble(),
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  static String _extractProductName(Map<String, dynamic> item) {
    // Priority order for extracting product name
    if (item['products'] != null && item['products']['name_en'] != null) {
      return item['products']['name_en'];
    }
  
    if (item['name_en'] != null) {
      return item['name'];
    }
    return 'unknown';
  }

  static String _extractProductImage(Map<String, dynamic> item) {
    if (item['products'] != null && item['products']['image_url'] != null) {
      return item['products']['image_url'];
    }
    if (item['image_url'] != null) {
      return item['image_url'];
    }
    return '';
  }

  OrderModel copyWith({
    String? id,
    List<Map<String, dynamic>>? items,
    double? totalAmount,
    String? customerName,
    String? customerPhone,
    String? deliveryAddress,
    String? status,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
