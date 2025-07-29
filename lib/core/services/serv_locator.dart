import 'package:get_it/get_it.dart';
import 'package:sweet_pal/auth/data/repos/auth_repos_implement.dart';
import 'package:sweet_pal/auth/domain/repos/auth_repo.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<SupabaseAuthService>(() => SupabaseAuthService());
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(getIt()));
}
