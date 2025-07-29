part of 'category_cubit.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Map<String, dynamic>> categories;

  CategoryLoaded(this.categories);
}

class CategorySelected extends CategoryState {
  final Map<String, dynamic> selectedCategory;

  CategorySelected(this.selectedCategory);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}
