import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon.dart';
import 'package:portfolio_luan/shared/widgets/navigation/bottom_nav_bar.dart';
import 'package:portfolio_luan/shared/widgets/navigation/bottom_nav_item.dart';
import 'package:portfolio_luan/shared/widgets/navigation/nav_destination.dart';

void main() {
  Future<void> pumpNav(
    WidgetTester tester, {
    required int currentIndex,
    ValueChanged<int>? onSelected,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomNavBar(
            palette: ScreenPalette.light,
            currentIndex: currentIndex,
            onDestinationSelected: onSelected ?? (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets('mostra as cinco abas do design, na ordem', (tester) async {
    await pumpNav(tester, currentIndex: 0);

    for (final destination in NavDestination.all) {
      expect(find.text(destination.label), findsOneWidget);
    }
  });

  testWidgets('pinta só a aba ativa com mostarda e sand', (tester) async {
    await pumpNav(tester, currentIndex: 2);

    final icons = tester.widgetList<AppIcon>(find.byType(AppIcon)).toList();
    expect(icons[2].color, AppColors.mustard);
    expect(icons[0].color, AppColors.mutedGray);
    expect(icons[4].color, AppColors.mutedGray);

    final activeLabel = tester.widget<Text>(
      find.text(NavDestination.all[2].label),
    );
    expect(activeLabel.style?.color, AppColors.sand);
    expect(
      activeLabel.style?.fontWeight,
      AppTypography.navLabelActive.fontWeight,
    );

    final inactiveLabel = tester.widget<Text>(
      find.text(NavDestination.all[0].label),
    );
    expect(inactiveLabel.style?.color, AppColors.mutedGray);
    expect(inactiveLabel.style?.fontWeight, AppTypography.navLabel.fontWeight);
  });

  testWidgets('a aba não desenha ripple quadrado ao ser tocada', (
    tester,
  ) async {
    await pumpNav(tester, currentIndex: 0);

    for (final item in tester.widgetList<InkWell>(find.byType(InkWell))) {
      expect(item.splashFactory, NoSplash.splashFactory);
      expect(item.splashColor, Colors.transparent);
      expect(item.highlightColor, Colors.transparent);
    }

    await tester.press(find.text(NavDestination.all[2].label));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(InkWell), findsNWidgets(NavDestination.all.length));
    expect(tester.takeException(), isNull);
  });

  Finder dotFinder() => find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration! as BoxDecoration).color == AppColors.mustard,
  );

  testWidgets('existe um único ponto, na aba selecionada', (tester) async {
    await pumpNav(tester, currentIndex: 0);

    expect(dotFinder(), findsOneWidget);

    final primeiro = tester.getCenter(dotFinder()).dx;
    final abaInicial = tester.getCenter(find.byType(BottomNavItem).first).dx;

    expect(primeiro, closeTo(abaInicial, 1));
  });

  testWidgets('o ponto desliza até a nova aba, sem sumir no caminho', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _NavHost())),
    );

    final partida = tester.getCenter(dotFinder()).dx;

    await tester.tap(find.text(NavDestination.all[3].label));
    await tester.pump();

    await tester.pump(AppDurations.navIndicator ~/ 2);
    expect(dotFinder(), findsOneWidget);
    final meio = tester.getCenter(dotFinder()).dx;

    await tester.pump(AppDurations.navIndicator);
    final chegada = tester.getCenter(dotFinder()).dx;

    final destino = tester.getCenter(find.byType(BottomNavItem).at(3)).dx;

    expect(chegada, closeTo(destino, 1));
    expect(meio, greaterThan(partida));
    expect(meio, lessThan(chegada));
  });

  testWidgets('avisa o índice tocado', (tester) async {
    final selected = <int>[];
    await pumpNav(tester, currentIndex: 0, onSelected: selected.add);

    await tester.tap(find.text(NavDestination.all[3].label));

    expect(selected, [3]);
  });
}

class _NavHost extends StatefulWidget {
  const _NavHost();

  @override
  State<_NavHost> createState() => _NavHostState();
}

class _NavHostState extends State<_NavHost> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(
      palette: ScreenPalette.light,
      currentIndex: _index,
      onDestinationSelected: (index) => setState(() => _index = index),
    );
  }
}
