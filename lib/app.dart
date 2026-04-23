import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/config/environment/app_environment.dart';
import 'package:flutter_app/config/routes/app_router.dart';
import 'package:flutter_app/core/di/injection_container.dart' as di;
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/shared/cubit/app_locale_cubit.dart';
import 'package:flutter_app/shared/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.environment,
  });

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AppLocaleCubit>.value(
          value: di.sl<AppLocaleCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
      ],
      child: BlocBuilder<AppLocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: environment.appName,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppTheme.light(),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: AppRouter.login,
            builder: (context, child) {
              final appChild = child ?? const SizedBox.shrink();
              if (environment.isProduction) {
                return appChild;
              }

              return Banner(
                message: environment.flavorName.toUpperCase(),
                location: BannerLocation.topStart,
                child: appChild,
              );
            },
          );
        },
      ),
    );
  }
}
