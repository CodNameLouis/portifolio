import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:portfolio_luan/app/app.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/shared/widgets/navigation/bottom_nav_item.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> assenta(WidgetTester tester) async {
    for (var quadro = 0; quadro < 20; quadro++) {
      await tester.pump(AppDurations.entrance);
    }
  }

  testWidgets('captura as cinco telas do app', (tester) async {
    await tester.pumpWidget(const App());

    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
    }

    await assenta(tester);
    await binding.takeScreenshot('01-inicio');

    final abas = {
      '02-projetos': AppStrings.navProjects,
      '03-stack': AppStrings.navStack,
      '04-trajetoria': AppStrings.navTrajectory,
      '05-contato': AppStrings.navContact,
    };

    for (final entrada in abas.entries) {
      await tester.tap(
        find
            .descendant(
              of: find.byType(BottomNavItem),
              matching: find.text(entrada.value),
            )
            .last,
      );
      await assenta(tester);
      await binding.takeScreenshot(entrada.key);
    }
  });
}
