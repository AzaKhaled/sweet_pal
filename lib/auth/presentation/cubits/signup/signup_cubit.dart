import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sweet_pal/auth/domain/entites/user_entity.dart';
import 'package:sweet_pal/auth/domain/repos/auth_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.authRepo) : super(SignupInitial());

  final AuthRepo authRepo;

  Future<void> signUp(String email, String password, String name) async {
    emit(SignupLoading());
    final result = await authRepo.signUp(email, password, name); 
    result.fold(
      (failure) => emit(SignupFailure(message: failure.message)),
      (user) => emit(SignupSuccess(userEntity: user)),
    );
  }
}

