import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweet_pal/features/home/presentation/data/product_model.dart';
import 'package:sweet_pal/features/home/presentation/views/cubit/products/product_cubit.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/product_view.dart';


class ProductListSection extends StatelessWidget {
  const ProductListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          final products = state.products;
          return ProductsPage(
            products: products.map((product) {
              return Product(
                nameAr: product['name_en'],
                id: product['id'],
                nameEn: product['name_en'],
                descriptionEn: product['description_en'],
                descriptionAr: product['description_ar'],
                imageUrl: product['image_url'],
                price: product['price'].toDouble(),
              );
            }).toList(),
          );
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
