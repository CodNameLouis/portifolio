import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/shared/widgets/layout/divided_column.dart';

void main() {
  Future<void> pumpColumn(
    WidgetTester tester, {
    EdgeInsets itemPadding = EdgeInsets.zero,
    double spacingBelow = 0,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DividedColumn(
            dividerColor: AppColors.navyAlpha18,
            itemPadding: itemPadding,
            spacingBelow: spacingBelow,
            children: const [Text('um'), Text('dois'), Text('três')],
          ),
        ),
      ),
    );
  }

  List<Container> wrappers(WidgetTester tester) => tester
      .widgetList<Container>(
        find.descendant(
          of: find.byType(DividedColumn),
          matching: find.byType(Container),
        ),
      )
      .toList();

  testWidgets('não desenha borda acima do primeiro item', (tester) async {
    await pumpColumn(tester);

    final items = wrappers(tester);
    expect(items, hasLength(3));
    expect(items.first.decoration, isNull);
  });

  testWidgets('desenha a borda superior nos demais itens', (tester) async {
    await pumpColumn(tester);

    final items = wrappers(tester);

    for (final item in items.skip(1)) {
      final border = (item.decoration! as BoxDecoration).border! as Border;
      expect(border.top.color, AppColors.navyAlpha18);
      expect(border.bottom, BorderSide.none);
    }
  });

  testWidgets('spacingBelow só afasta o conteúdo abaixo da linha', (
    tester,
  ) async {
    await pumpColumn(
      tester,
      itemPadding: const EdgeInsets.symmetric(vertical: 4),
      spacingBelow: 12,
    );

    final items = wrappers(tester);
    expect(items.first.padding, const EdgeInsets.symmetric(vertical: 4));
    expect(items[1].padding, const EdgeInsets.fromLTRB(0, 16, 0, 4));
  });
}
