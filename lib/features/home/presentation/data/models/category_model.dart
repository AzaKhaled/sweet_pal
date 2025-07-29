class Category {
  final int id;
  final String name;
  final String imageUrl;

  Category({required this.id, required this.name, required this.imageUrl});
  
  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as int,
    name: map['name_en'] as String,
    imageUrl: map['image_url'] as String,
  );
}
