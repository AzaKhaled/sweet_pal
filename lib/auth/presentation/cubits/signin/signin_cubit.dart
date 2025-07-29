import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sweet_pal/auth/domain/entites/user_entity.dart';
import 'package:sweet_pal/auth/domain/repos/auth_repo.dart';


part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());

  final AuthRepo authRepo;

  Future<void> signIn(String email, String password) async {
    emit(SigninLoading());
    final result = await authRepo.signIn(email, password);
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (user) => emit(SigninSuccess(userEntity: user)),
    );
  }

 
}
