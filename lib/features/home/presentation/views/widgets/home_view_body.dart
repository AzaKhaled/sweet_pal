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
    setState(() {
      selectedCategoryId = id;
      selectedCategoryName = name;
    });
    context.read<ProductCubit>().fetchProductsByCategory(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderSection(),
           Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  if (selectedCategoryId == null)
                    CategoryGridSection(onSelect: selectCategory),
                  if (selectedCategoryId != null)
                    CategoryHorizontalList(
                      selectedId: selectedCategoryId!,
                      onSelect: selectCategory,
                    ),
                  const SizedBox(height: 16),
                  if (selectedCategoryId != null) const ProductListSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
