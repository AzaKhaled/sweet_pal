import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';

part 'product_state.dart';

// lib/features/home/presentation/manager/product_cubit.dart
class ProductCubit extends Cubit<ProductState> {
  final SupabaseAuthService supabaseService;

  ProductCubit(this.supabaseService) : super(ProductInitial());

  Future<void> fetchProductsByCategory(String categoryId) async {
    emit(ProductLoading());
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select('*')
          .eq('category_id', categoryId);

      emit(ProductLoaded(List<Map<String, dynamic>>.from(response)));
    } catch (e) {
      emit(ProductError('Failed to load products'));
    }
  }

  void clearProducts() {
    emit(ProductInitial());
  }
}
