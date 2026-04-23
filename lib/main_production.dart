import 'package:flutter_app/bootstrap.dart';
import 'package:flutter_app/config/environment/app_environment.dart';

Future<void> main() async {
  await bootstrap(AppFlavor.production);
}
