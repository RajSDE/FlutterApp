import 'package:flutter/material.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/config/environment/app_environment.dart';
import 'package:flutter_app/core/di/injection_container.dart' as di;
import 'package:flutter_app/shared/cubit/app_locale_cubit.dart';

Future<void> bootstrap(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  final environment = AppEnvironment.fromFlavor(flavor);
  await di.init(
    reset: true,
    environment: environment,
  );
  await di.sl<AppLocaleCubit>().loadSavedLocale();
  runApp(MyApp(environment: environment));
}
