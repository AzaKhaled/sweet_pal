import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/auth/domain/repos/product_repo.dart';
import 'package:sweet_pal/features/home/presentation/data/product_model.dart';

class ProductRepoImpl implements ProductRepo {
  final _client = Supabase.instance.client;

  @override
  Future<List<Product>> fetchProductsFromCategory(int categoryId) async {
    final response = await _client
        .from('products')
        .select('*')
        .eq('category_id', categoryId)
        .limit(10); // حسب المطلوب

    return (response as List)
        .map((e) => Product.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
