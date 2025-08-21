import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweet_pal/features/home/presentation/views/cubit/products/product_cubit.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/Category_horizontal_Item.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/category_iteams.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/header_section.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/product_item.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final TextEditingController searchController = TextEditingController();

  String? selectedCategoryId;
  String? selectedCategoryName;

  void selectCategory(String id, String name) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          selectedCategoryId = id;
          selectedCategoryName = name;
        });
      }
    });
    context.read<ProductCubit>().fetchProductsByCategory(id);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        body: Column(
          children: [
            // Header Section
            const HeaderSection(),

            // باقي الجسم
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedCategoryId == null)
                            CategoryGridSection(onSelect: selectCategory),

                          if (selectedCategoryId != null) ...[
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 8),
                            //   child: Row(
                            //     children: [
                            //       IconButton(
                            //         onPressed: () {
                            //           setState(() {
                            //             selectedCategoryId = null;
                            //             selectedCategoryName = null;
                            //           });
                            //           context.read<ProductCubit>().clearProducts();
                            //         },
                            //         icon: const Icon(Icons.arrow_back),
                            //         iconSize: 20,
                            //       ),
                            //       Text(
                            //         selectedCategoryName ?? 'Products',
                            //         style: const TextStyle(
                            //           fontSize: 16,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CategoryHorizontalList(
                                selectedId: selectedCategoryId!,
                                onSelect: selectCategory,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Products Section
                    if (selectedCategoryId != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: const ProductListSection(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
