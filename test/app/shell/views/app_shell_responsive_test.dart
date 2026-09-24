import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/app/app.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_header.dart';
import 'package:portfolio_luan/shared/widgets/layout/responsive_frame.dart';
import 'package:portfolio_luan/shared/widgets/navigation/bottom_nav_bar.dart';

import '../../../support/fake_asset_bundle.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(App(bundle: FakeAssetBundle()));
    await tester.pump();
    await tester.pump(AppDurations.entrance + AppDurations.entranceStagger * 5);
  }

  testWidgets('em janela larga o conteúdo fica limitado e centralizado', (
    tester,
  ) async {
    const largura = 1200.0;
    await pumpApp(tester, const Size(largura, 900));

    final frame = tester.getRect(find.byType(ResponsiveFrame));
    expect(frame.width, largura);

    final header = tester.getRect(find.byType(PageHeader));
    expect(header.width, lessThanOrEqualTo(AppSizes.responsiveMaxWidth));

    final nav = tester.getRect(find.byType(BottomNavBar));
    expect(nav.width, lessThanOrEqualTo(AppSizes.responsiveMaxWidth));

    final folgaEsquerda = header.left;
    final folgaDireita = largura - header.right;
    expect(folgaEsquerda, closeTo(folgaDireita, 1));
  });

  testWidgets('o fundo preenche a janela inteira, não só o frame', (
    tester,
  ) async {
    const largura = 1200.0;
    const altura = 900.0;
    await pumpApp(tester, const Size(largura, altura));

    final fundo = tester.getRect(find.byType(AnimatedContainer).first);
    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );

    expect(fundo.width, largura);
    expect(fundo.height, altura);
    expect(
      (container.decoration! as BoxDecoration).color,
      ScreenPalette.light.background,
    );
  });

  testWidgets('em tela estreita o conteúdo ocupa a largura toda', (
    tester,
  ) async {
    const largura = 390.0;
    await pumpApp(tester, const Size(largura, 844));

    final header = tester.getRect(find.byType(PageHeader));

    expect(header.width, largura);
  });
}
