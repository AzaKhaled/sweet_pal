class Category {
  final int id;
  final String nameEn;
  final String nameAr;
  final String imageUrl;

  Category({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
  });
  
  String getLocalizedName(String locale) {
    if (locale.startsWith('ar')) {
      return nameAr.isNotEmpty ? nameAr : nameEn;
    } else {
      return nameEn;
    }
  }
  
  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as int,
    nameEn: map['name_en'] as String,
    nameAr: map['name_ar'] as String,
    imageUrl: map['image_url'] as String,
  );
}
