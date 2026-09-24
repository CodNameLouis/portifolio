import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/shared/widgets/chips/filter_pill.dart';

void main() {
  Future<void> pumpPill(
    WidgetTester tester, {
    required bool selected,
    VoidCallback? onPressed,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilterPill(
            label: AppStrings.categoryMaps,
            selected: selected,
            selectedBackground: AppColors.navy,
            selectedForeground: AppColors.sand,
            foreground: AppColors.navy,
            borderColor: AppColors.navyAlpha28,
            onPressed: onPressed ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('selecionado: fundo navy, texto sand e peso 600', (tester) async {
    await pumpPill(tester, selected: true);

    final pill = tester.widget<Container>(
      find.descendant(
        of: find.byType(FilterPill),
        matching: find.byType(Container),
      ),
    );
    final decoration = pill.decoration! as ShapeDecoration;
    expect(decoration.color, AppColors.navy);

    final label = tester.widget<Text>(find.text(AppStrings.categoryMaps));
    expect(label.style?.color, AppColors.sand);
    expect(label.style?.fontWeight, AppTypography.captionStrong.fontWeight);
  });

  testWidgets('não selecionado: fundo transparente, borda e peso 500', (
    tester,
  ) async {
    await pumpPill(tester, selected: false);

    final pill = tester.widget<Container>(
      find.descendant(
        of: find.byType(FilterPill),
        matching: find.byType(Container),
      ),
    );
    final decoration = pill.decoration! as ShapeDecoration;
    expect(decoration.color, Colors.transparent);

    final shape = decoration.shape as StadiumBorder;
    expect(shape.side.color, AppColors.navyAlpha28);

    final label = tester.widget<Text>(find.text(AppStrings.categoryMaps));
    expect(label.style?.color, AppColors.navy);
    expect(label.style?.fontWeight, AppTypography.captionMedium.fontWeight);
  });

  testWidgets('a área de toque tem ao menos 44 de altura', (tester) async {
    await pumpPill(tester, selected: false);

    final alvo = tester.getSize(find.byType(FilterPill));
    final visual = tester.getSize(
      find.descendant(
        of: find.byType(FilterPill),
        matching: find.byType(Container),
      ),
    );

    expect(alvo.height, greaterThanOrEqualTo(AppSizes.minTouchTarget));
    expect(visual.height, AppSizes.filterPill);
  });

  testWidgets('avisa o toque', (tester) async {
    var taps = 0;
    await pumpPill(tester, selected: false, onPressed: () => taps++);

    await tester.tap(find.byType(FilterPill));

    expect(taps, 1);
  });
}
