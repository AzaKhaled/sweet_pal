import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/auth/domain/entites/user_entity.dart';
import 'package:sweet_pal/auth/domain/repos/auth_repo.dart';
import 'package:sweet_pal/core/errors/exceptions.dart';
import 'package:sweet_pal/core/errors/failures.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';

class AuthRepoImpl extends AuthRepo {
  final SupabaseAuthService supabaseAuthService;

  AuthRepoImpl(this.supabaseAuthService);

  @override
  Future<Either<Failure, UserEntity>> signUp(String email,String password,String name,)
 async {
    try {
final user = await supabaseAuthService.signUp(email, password, name);
      return right(UserEntity(id: user.id, email: user.email ?? ''));
    } on CustomException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    try {
      final user = await supabaseAuthService.signIn(email, password);
      return right(UserEntity(id: user.id, email: user.email ?? ''));
    } on CustomException catch (e) {
      return left(Failure(message: e.message));
    }
  }


  @override
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
