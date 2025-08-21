import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sweet_pal/core/services/storage_service.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SupabaseAuthService authService;
  final StorageService storageService;

  ProfileCubit(this.authService, this.storageService) : super(ProfileInitial());

  Future<void> uploadImage(File imageFile) async {
    emit(ProfileLoading());
    try {
      final imageUrl = await storageService.uploadProfileImage(imageFile);
      await authService.updateProfileImage(imageUrl);
      emit(ProfileSuccess('updated successfully!'));
    } catch (e) {
      // print(e.toString());
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> changePassword(String newPassword) async {
    emit(ProfileLoading());
    try {
      await authService.changePassword(newPassword);
      emit(ProfileSuccess('Password changed successfully!'));
    } catch (e) {
      // print(e.toString());
      emit(ProfileError(e.toString()));
    }
  }
}
