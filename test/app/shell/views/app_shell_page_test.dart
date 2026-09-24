import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_luan/app/app.dart';
import 'package:portfolio_luan/app/router/app_routes.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/contact/views/contact_page.dart';
import 'package:portfolio_luan/features/home/views/home_page.dart';
import 'package:portfolio_luan/features/trajectory/views/trajectory_page.dart';
import 'package:portfolio_luan/shared/widgets/buttons/outline_pill_button.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_header.dart';

import '../../../support/fake_asset_bundle.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(App(bundle: FakeAssetBundle()));
    await tester.pump();
    await tester.pump(AppDurations.paletteTransition);
  }

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pump(AppDurations.paletteTransition);
  }

  Color shellBackground(WidgetTester tester) {
    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    final decoration = container.decoration as BoxDecoration?;
    return decoration?.color ?? Colors.transparent;
  }

  String currentLocation(WidgetTester tester) {
    final context = tester.element(find.byType(PageHeader).first);
    return GoRouterState.of(context).uri.toString();
  }

  testWidgets('abre na Início com a paleta clara', (tester) async {
    await pumpApp(tester);

    expect(find.byType(HomePage), findsOneWidget);
    expect(shellBackground(tester), ScreenPalette.light.background);
    expect(currentLocation(tester), AppRoutes.home);
  });

  testWidgets('troca de aba, de paleta e de URL ao tocar na nav', (
    tester,
  ) async {
    await pumpApp(tester);

    await tapTab(tester, AppStrings.navTrajectory);

    expect(find.byType(TrajectoryPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
    expect(shellBackground(tester), ScreenPalette.dark.background);
    expect(currentLocation(tester), AppRoutes.trajectory);

    await tapTab(tester, AppStrings.navContact);

    expect(find.byType(ContactPage), findsOneWidget);
    expect(shellBackground(tester), ScreenPalette.accent.background);
    expect(currentLocation(tester), AppRoutes.contact);
  });

  testWidgets('volta para a Início mantendo a paleta clara', (tester) async {
    await pumpApp(tester);

    await tapTab(tester, AppStrings.navStack);
    await tapTab(tester, AppStrings.navHome);

    expect(find.byType(HomePage), findsOneWidget);
    expect(shellBackground(tester), ScreenPalette.light.background);
    expect(currentLocation(tester), AppRoutes.home);
  });

  testWidgets('os botões da Início levam para Projetos e Contato', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text(AppStrings.homeViewProjects));
    await tester.pump();
    await tester.pump(AppDurations.paletteTransition);

    expect(currentLocation(tester), AppRoutes.projects);

    await tapTab(tester, AppStrings.navHome);

    await tester.tap(
      find.widgetWithText(OutlinePillButton, AppStrings.homeContact),
    );
    await tester.pump();
    await tester.pump(AppDurations.paletteTransition);

    expect(currentLocation(tester), AppRoutes.contact);
  });
}
