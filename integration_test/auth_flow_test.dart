import 'package:flutter/material.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/config/environment/app_environment.dart';
import 'package:flutter_app/core/di/injection_container.dart' as di;
import 'package:flutter_app/core/security/secure_storage.dart';
import 'package:flutter_app/shared/cubit/app_locale_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpApp(WidgetTester tester) async {
    await di.init(
      reset: true,
      environment: AppEnvironment.fromFlavor(AppFlavor.development),
    );
    await di.sl<SecureStorageService>().deleteAll();
    await di.sl<AppLocaleCubit>().loadSavedLocale();
    await tester.pumpWidget(MyApp(environment: di.sl<AppEnvironment>()));
    await tester.pumpAndSettle();
  }

  testWidgets('completes signup flow', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text("Don't have an account? Sign up"));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'tester@example.com');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome! You are logged in.'), findsOneWidget);
  });

  testWidgets('completes OTP login flow', (tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField).first, '9876543210');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Verify OTP'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.text('Verify OTP'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome! You are logged in.'), findsOneWidget);
  });
}
