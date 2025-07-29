import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sweet_pal/core/services/storage_service.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SupabaseAuthService authService;
  final StorageService storageService;

  ProfileCubit(this.authService, this.storageService)
      : super(ProfileInitial());

  Future<void> updateProfileImage(File image) async {
    emit(ProfileLoading());

    try {
      final url = await storageService.uploadProfileImage(image);
      await authService.updateProfileImage(url);
      emit(ProfileSuccess("تم تحديث الصورة بنجاح"));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> changePassword(String newPassword) async {
    emit(ProfileLoading());

    try {
      await authService.changePassword(newPassword);
      emit(ProfileSuccess("تم تغيير كلمة المرور"));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
