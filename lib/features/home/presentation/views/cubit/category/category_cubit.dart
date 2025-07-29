// lib/features/home/presentation/manager/category_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final SupabaseAuthService supabaseService;

  Map<String, dynamic>? _selectedCategory;

  CategoryCubit(this.supabaseService) : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await supabaseService.fetchCategoriesWithProducts();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories'));
    }
  }

  void selectCategory(Map<String, dynamic> category) {
    _selectedCategory = category;
    emit(CategorySelected(category));
  }

  void clearSelection() {
    _selectedCategory = null;
    fetchCategories(); 
  }
}
