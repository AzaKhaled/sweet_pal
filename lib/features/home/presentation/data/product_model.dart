class Product {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      nameAr: map['name_ar'] ?? '',
      nameEn: map['name_en'] ?? '',
      descriptionAr: map['description_ar'] ?? '',
      descriptionEn: map['description_en'] ?? '',
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'] ?? '',
    );
  }
}
