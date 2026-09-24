import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/shared/widgets/layout/fade_slide_in.dart';

void main() {
  double opacidade(WidgetTester tester) {
    return tester
        .widget<Opacity>(
          find.descendant(
            of: find.byType(FadeSlideIn),
            matching: find.byType(Opacity),
          ),
        )
        .opacity;
  }

  testWidgets('começa invisível e termina visível', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FadeSlideIn(child: Text('oi'))),
      ),
    );

    expect(opacidade(tester), 0);

    await tester.pump(AppDurations.entrance);

    expect(opacidade(tester), 1);
  });

  testWidgets('o texto entra deslizando de baixo', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: FadeSlideIn(child: Text('oi'))),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1));
    final inicio = tester.getTopLeft(find.text('oi')).dy;

    await tester.pump(AppDurations.entrance);
    final fim = tester.getTopLeft(find.text('oi')).dy;

    expect(inicio, greaterThan(fim));
  });

  testWidgets('order atrasa a entrada', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              FadeSlideIn(child: Text('primeiro')),
              FadeSlideIn(order: 3, child: Text('quarto')),
            ],
          ),
        ),
      ),
    );

    await tester.pump(AppDurations.entrance);

    final opacidades = tester
        .widgetList<Opacity>(
          find.descendant(
            of: find.byType(FadeSlideIn),
            matching: find.byType(Opacity),
          ),
        )
        .map((widget) => widget.opacity)
        .toList();

    expect(opacidades.first, 1);
    expect(opacidades.last, lessThan(1));

    await tester.pump(AppDurations.entranceStagger * 3);

    final finais = tester
        .widgetList<Opacity>(
          find.descendant(
            of: find.byType(FadeSlideIn),
            matching: find.byType(Opacity),
          ),
        )
        .map((widget) => widget.opacity);

    expect(finais, everyElement(1.0));
  });
}
