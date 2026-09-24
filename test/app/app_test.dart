import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/app/app.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/features/home/views/home_page.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_title.dart';

import '../support/fake_asset_bundle.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(App(bundle: FakeAssetBundle()));
    await tester.pump();
    await tester.pump(AppDurations.paletteTransition);
  }

  testWidgets('aplica o tema do design system no MaterialApp', (tester) async {
    await pumpApp(tester);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final theme = app.theme;

    expect(theme, isNotNull);

    final pageTitle = theme!.textTheme.displaySmall;
    expect(pageTitle?.fontFamily, AppTypography.displayFamily);
    expect(pageTitle?.fontSize, AppTypography.pageTitle.fontSize);
    expect(pageTitle?.fontWeight, AppTypography.pageTitle.fontWeight);
    expect(pageTitle?.color, AppColors.navy);

    expect(theme.textTheme.bodyMedium?.fontFamily, AppTypography.textFamily);
    expect(theme.scaffoldBackgroundColor, Colors.transparent);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('renderiza texto sob um Material, com a cor do tema', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text(AppStrings.navProjects));
    await tester.pump();
    await tester.pump(AppDurations.paletteTransition);

    expect(find.byType(Material), findsWidgets);

    final rendered = tester.widget<RichText>(
      find.descendant(
        of: find.descendant(
          of: find.byType(PageTitle),
          matching: find.text(AppStrings.projectsTitle),
        ),
        matching: find.byType(RichText),
      ),
    );

    expect(rendered.text.style?.color, AppColors.navy);
    expect(rendered.text.style?.decoration, TextDecoration.none);
  });
}
