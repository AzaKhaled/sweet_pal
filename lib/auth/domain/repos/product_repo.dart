import 'package:sweet_pal/features/home/presentation/data/product_model.dart';

abstract class ProductRepo {
  Future<List<Product>> fetchProductsFromCategory(int categoryId);
}
