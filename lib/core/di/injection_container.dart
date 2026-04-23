import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/config/environment/app_environment.dart';
import 'package:flutter_app/core/network/api_client.dart';
import 'package:flutter_app/core/network/interceptors/app_log_interceptor.dart';
import 'package:flutter_app/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_app/core/network/interceptors/mock_backend_interceptor.dart';
import 'package:flutter_app/core/network/network_service.dart';
import 'package:flutter_app/core/security/secure_storage.dart';
import 'package:flutter_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/request_login_otp.dart';
import 'package:flutter_app/features/auth/domain/usecases/signup_with_email.dart';
import 'package:flutter_app/features/auth/domain/usecases/verify_login_otp.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/shared/cubit/app_locale_cubit.dart';

final sl = GetIt.instance;

Future<void> init({
  AppEnvironment? environment,
  bool reset = false,
}) async {
  if (reset) {
    await sl.reset();
  }

  sl.registerLazySingleton<AppEnvironment>(
    () => environment ?? AppEnvironment.fromFlavor(AppFlavor.development),
  );
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<SecureStorageService>(SecureStorageService.new);
  sl.registerLazySingleton<MockBackendInterceptor>(
    () => MockBackendInterceptor(enabled: sl<AppEnvironment>().useMockServer),
  );
  sl.registerLazySingleton<AppLogInterceptor>(
    () => AppLogInterceptor(enabled: sl<AppEnvironment>().enableNetworkLogs),
  );
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      dio: sl<Dio>(),
      secureStorageService: sl<SecureStorageService>(),
      refreshInterceptors: <Interceptor>[
        sl<MockBackendInterceptor>(),
        sl<AppLogInterceptor>(),
      ],
    ),
  );
  sl.registerLazySingleton<NetworkService>(
    () => NetworkService(
      dio: sl<Dio>(),
      environment: sl<AppEnvironment>(),
      interceptors: <Interceptor>[
        sl<AuthInterceptor>(),
        sl<MockBackendInterceptor>(),
        sl<AppLogInterceptor>(),
      ],
    ),
  );
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<NetworkService>()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      secureStorageService: sl<SecureStorageService>(),
    ),
  );

  sl.registerLazySingleton(() => RequestLoginOtp(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyLoginOtp(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignupWithEmail(sl<AuthRepository>()));

  sl.registerLazySingleton(
    () => AppLocaleCubit(secureStorageService: sl<SecureStorageService>()),
  );

  sl.registerFactory(
    () => AuthBloc(
      requestLoginOtp: sl<RequestLoginOtp>(),
      verifyLoginOtp: sl<VerifyLoginOtp>(),
      signupWithEmail: sl<SignupWithEmail>(),
    ),
  );
}
