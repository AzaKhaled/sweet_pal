import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SupabaseClient _client = Supabase.instance.client;

  UserCubit() : super(UserInitial());

  Future<void> fetchUserData() async {
    emit(UserLoading());
    final user = _client.auth.currentUser;
    if (user == null) {
      emit(UserError('User not logged in'));
      return;
    }

    try {
      final response = await _client
          .from('users')
          .select()
          .eq('auth_id', user.id)
          .maybeSingle();

      if (response != null) {
  final avatarUrl = response['avatar_url'];
  if (avatarUrl != null && avatarUrl is String && avatarUrl.isNotEmpty) {
    // أضف ts للرابط علشان الصورة تتحدث دايمًا
    response['avatar_url'] = '$avatarUrl?ts=${DateTime.now().millisecondsSinceEpoch}';
  }
  emit(UserLoaded(response));
}
 else {
        emit(UserError('User not found in database'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
