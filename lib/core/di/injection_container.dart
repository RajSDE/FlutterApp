import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/core/network/api_client.dart';
import 'package:flutter_app/core/security/secure_storage.dart';
import 'package:flutter_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_user.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));
  sl.registerLazySingleton<SecureStorageService>(SecureStorageService.new);

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      secureStorageService: sl<SecureStorageService>(),
    ),
  );

  sl.registerLazySingleton(() => LoginUser(sl<AuthRepository>()));

  sl.registerFactory(() => AuthBloc(loginUser: sl<LoginUser>()));
}
