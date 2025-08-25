import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/features/home/presentation/views/cubit/category/category_cubit.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';


class CategoryHorizontalList extends StatelessWidget {
  final String selectedId;
  final Function(String id, String name) onSelect;

  const CategoryHorizontalList({
    super.key,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          final categories = state.categories;
          return SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () => onSelect(category['id'], category['name_en']),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: category['id'] == selectedId
                          ? AppColors.primaryColor
                          : Provider.of<ThemeProvider>(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            category['image_url'],
                            height: 40,
                            width: 60,
                            fit: BoxFit.cover,
                            cacheWidth: 60, // Optimize image size
                            cacheHeight: 40, // Optimize image size
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          category['name_en'],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            color: Provider.of<ThemeProvider>(context).textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}