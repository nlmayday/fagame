import 'package:get_it/get_it.dart';
import 'package:fagame/core/config/environment.dart';
import 'package:fagame/features/auth/data/mock_repository.dart';
import 'package:fagame/features/auth/data/real_repository.dart';
import 'package:fagame/features/auth/data/repository.dart';
import 'package:fagame/features/auth/domain/usecases/login_usecase.dart';
import 'package:fagame/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fagame/features/auth/domain/usecases/register_usecase.dart';
import 'package:fagame/features/auth/presentation/cubit/auth_cubit.dart';

/// 注册认证模块依赖
void registerAuthDependencies(GetIt sl, Environment environment) {
  // Repository
  sl.registerLazySingleton<AuthRepository>(() {
    return environment.useMock
        ? MockAuthRepository()
        : RealAuthRepository(httpClient: sl());
  });

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Cubit
  sl.registerFactory(() => AuthCubit(loginUseCase: sl(), logoutUseCase: sl()));
}
