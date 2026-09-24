import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/shared/widgets/chips/badge_pill.dart';
import 'package:portfolio_luan/shared/widgets/chips/filter_pill.dart';
import 'package:portfolio_luan/shared/widgets/chips/tag_chip.dart';

void main() {
  const largura = 390.0;

  Future<void> pumpInWrap(WidgetTester tester, List<Widget> children) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: largura,
            child: Wrap(children: children),
          ),
        ),
      ),
    );
  }

  testWidgets('TagChip tem a largura do texto, não a do espaço disponível', (
    tester,
  ) async {
    await pumpInWrap(tester, const [
      TagChip(
        label: 'GetX',
        foreground: AppColors.navy,
        borderColor: AppColors.navyAlpha28,
      ),
    ]);

    final chip = tester.getSize(find.byType(TagChip));
    final texto = tester.getSize(find.text('GetX'));

    expect(chip.height, AppSizes.tagChip);
    expect(chip.width, lessThan(largura / 2));
    expect(
      chip.width,
      closeTo(texto.width + AppSpacing.md * 2 + AppSizes.hairline * 2, 1),
    );
  });

  testWidgets('vários TagChip cabem na mesma linha', (tester) async {
    await pumpInWrap(tester, const [
      TagChip(
        label: 'GetX',
        foreground: AppColors.navy,
        borderColor: AppColors.navyAlpha28,
      ),
      TagChip(
        label: 'MobX',
        foreground: AppColors.navy,
        borderColor: AppColors.navyAlpha28,
      ),
      TagChip(
        label: 'Provider',
        foreground: AppColors.navy,
        borderColor: AppColors.navyAlpha28,
      ),
    ]);

    final tops = tester
        .widgetList<TagChip>(find.byType(TagChip))
        .map((chip) => tester.getTopLeft(find.byWidget(chip)).dy)
        .toSet();

    expect(tops, hasLength(1));
  });

  testWidgets('BadgePill tem a largura do texto', (tester) async {
    await pumpInWrap(tester, const [BadgePill(label: 'Destaque')]);

    final badge = tester.getSize(find.byType(BadgePill));
    final texto = tester.getSize(find.text('Destaque'));

    expect(badge.height, AppSizes.badgePill);
    expect(badge.width, closeTo(texto.width + AppSpacing.m * 2, 1));
  });

  testWidgets('FilterPill tem a largura do texto', (tester) async {
    await pumpInWrap(tester, [
      FilterPill(
        label: 'Pagamentos',
        selected: false,
        selectedBackground: AppColors.navy,
        selectedForeground: AppColors.sand,
        foreground: AppColors.navy,
        borderColor: AppColors.navyAlpha28,
        onPressed: () {},
      ),
    ]);

    final pill = tester.getSize(find.byType(FilterPill));
    final texto = tester.getSize(find.text('Pagamentos'));

    expect(pill.height, AppSizes.minTouchTarget);
    expect(
      pill.width,
      closeTo(texto.width + AppSpacing.xl * 2 + AppSizes.hairline * 2, 1),
    );
  });
}
