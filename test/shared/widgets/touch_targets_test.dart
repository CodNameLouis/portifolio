import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/shared/widgets/brand/logo_badge.dart';
import 'package:portfolio_luan/shared/widgets/buttons/circle_arrow_button.dart';
import 'package:portfolio_luan/shared/widgets/buttons/outline_pill_button.dart';
import 'package:portfolio_luan/shared/widgets/buttons/primary_pill_button.dart';
import 'package:portfolio_luan/shared/widgets/navigation/bottom_nav_bar.dart';
import 'package:portfolio_luan/shared/widgets/navigation/bottom_nav_item.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  void esperaAlvoMinimo(WidgetTester tester, Finder finder) {
    for (final size in finder.evaluate().map(
      (element) => tester.getSize(find.byWidget(element.widget)),
    )) {
      expect(size.height, greaterThanOrEqualTo(AppSizes.minTouchTarget));
      expect(size.width, greaterThanOrEqualTo(AppSizes.minTouchTarget));
    }
  }

  testWidgets('CircleArrowButton tem alvo de 44 com círculo de 40', (
    tester,
  ) async {
    await pump(
      tester,
      CircleArrowButton(
        color: AppColors.navy,
        borderColor: AppColors.navyAlpha25,
        onPressed: () {},
      ),
    );

    esperaAlvoMinimo(tester, find.byType(CircleArrowButton));

    final circulo = tester.getSize(
      find
          .descendant(of: find.byType(InkWell), matching: find.byType(SizedBox))
          .first,
    );
    expect(circulo.height, AppSizes.circleArrow);
  });

  testWidgets('LogoBadge tem alvo de 44', (tester) async {
    await pump(tester, const LogoBadge(palette: ScreenPalette.light));

    esperaAlvoMinimo(tester, find.byType(LogoBadge));
  });

  testWidgets('os botões pill têm alvo de 52', (tester) async {
    await pump(
      tester,
      Row(
        children: [
          Expanded(
            child: PrimaryPillButton(
              label: AppStrings.homeViewProjects,
              background: AppColors.terracotta,
              foreground: AppColors.white,
              onPressed: () {},
            ),
          ),
          OutlinePillButton(
            label: AppStrings.homeContact,
            foreground: AppColors.navy,
            width: AppSizes.outlineButtonWidth,
            onPressed: () {},
          ),
        ],
      ),
    );

    esperaAlvoMinimo(tester, find.byType(PrimaryPillButton));
    esperaAlvoMinimo(tester, find.byType(OutlinePillButton));
  });

  testWidgets('cada aba da nav tem alvo de 44', (tester) async {
    await pump(
      tester,
      BottomNavBar(
        palette: ScreenPalette.light,
        currentIndex: 0,
        onDestinationSelected: (_) {},
      ),
    );

    esperaAlvoMinimo(tester, find.byType(BottomNavItem));
  });

  testWidgets('os botões expõem semântica de botão', (tester) async {
    final handle = tester.ensureSemantics();

    await pump(
      tester,
      PrimaryPillButton(
        label: AppStrings.homeViewProjects,
        background: AppColors.terracotta,
        foreground: AppColors.white,
        onPressed: () {},
      ),
    );

    final node = tester.getSemantics(find.byType(PrimaryPillButton));

    expect(node.label, AppStrings.homeViewProjects);
    expect(node.flagsCollection.isButton, isTrue);
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    handle.dispose();
  });
}
