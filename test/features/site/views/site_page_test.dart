import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_luan/app/app.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/features/site/views/site_page.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_contact_section.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_featured_project.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_footer.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_header.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_hero.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_phone_mockup.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_project_tile.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_stack_section.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_trajectory_section.dart';
import 'package:portfolio_luan/shared/widgets/chips/status_pill.dart';
import 'package:portfolio_luan/shared/widgets/navigation/bottom_nav_bar.dart';

import '../../../support/fake_asset_bundle.dart';

void main() {
  Future<void> pumpSite(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(App(bundle: FakeAssetBundle(), site: true));
    await tester.pump();
    await tester.pump(AppDurations.entrance);
  }

  testWidgets('a web mostra o site, não o shell de abas', (tester) async {
    await pumpSite(tester, const Size(1440, 1200));

    expect(find.byType(SitePage), findsOneWidget);
    expect(find.byType(BottomNavBar), findsNothing);
    expect(find.byType(SiteHeader), findsOneWidget);
    expect(find.byType(SiteHero), findsOneWidget);
  });

  testWidgets('o header traz marca, seções e chamada para contato', (
    tester,
  ) async {
    await pumpSite(tester, const Size(1440, 1200));

    final header = find.byType(SiteHeader);

    for (final secao in [
      AppStrings.navProjects,
      AppStrings.navStack,
      AppStrings.navTrajectory,
      AppStrings.navContact,
    ]) {
      expect(
        find.descendant(of: header, matching: find.text(secao)),
        findsOneWidget,
      );
    }

    expect(
      find.descendant(of: header, matching: find.text(AppStrings.appTitle)),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: header,
        matching: find.text(AppStrings.siteContactCta),
      ),
      findsOneWidget,
    );
    expect(find.byType(StatusPill), findsOneWidget);
  });

  testWidgets('a página tem todas as seções e o rodapé', (tester) async {
    await pumpSite(tester, const Size(1440, 1200));

    expect(find.byType(SiteFeaturedProject), findsOneWidget);
    expect(find.byType(SiteProjectTile), findsWidgets);
    expect(find.byType(SiteStackSection), findsOneWidget);
    expect(find.byType(SiteTrajectorySection), findsOneWidget);
    expect(find.byType(SiteContactSection), findsOneWidget);
    expect(find.byType(SiteFooter), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('o conteúdo respeita a largura máxima em tela muito larga', (
    tester,
  ) async {
    await pumpSite(tester, const Size(2200, 1200));

    final header = tester.getRect(find.byType(SiteHeader));
    expect(header.width, 2200);

    final marca = tester.getRect(find.text(AppStrings.appTitle));
    final folgaEsquerda = marca.left;
    expect(
      folgaEsquerda,
      greaterThanOrEqualTo(
        (2200 - SiteMetrics.maxWidth) / 2 + SiteMetrics.gutter,
      ),
    );
  });

  testWidgets('em tela estreita o header esconde nav e status', (tester) async {
    await pumpSite(tester, const Size(600, 1200));

    final header = find.byType(SiteHeader);

    expect(
      find.descendant(of: header, matching: find.text(AppStrings.navStack)),
      findsNothing,
    );
    expect(find.byType(StatusPill), findsNothing);
    expect(
      find.descendant(
        of: header,
        matching: find.text(AppStrings.siteContactCta),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('o menu rola a página sem trocar a URL', (tester) async {
    await pumpSite(tester, const Size(1440, 1000));

    final scroll = tester.state<ScrollableState>(find.byType(Scrollable).first);
    expect(scroll.position.pixels, 0);

    final rota = GoRouter.of(
      tester.element(find.byType(SitePage)),
    ).state.uri.toString();

    await tester.tap(
      find.descendant(
        of: find.byType(SiteHeader),
        matching: find.text(AppStrings.navStack),
      ),
    );
    await tester.pumpAndSettle();

    expect(scroll.position.pixels, greaterThan(0));

    final rotaDepois = GoRouter.of(
      tester.element(find.byType(SitePage)),
    ).state.uri.toString();

    expect(rotaDepois, rota);
  });

  testWidgets('o destaque usa o print do próprio projeto', (tester) async {
    await pumpSite(tester, const Size(1440, 1000));

    final card = tester.widget<SiteFeaturedProject>(
      find.byType(SiteFeaturedProject),
    );
    final mockups = tester
        .widgetList<SitePhoneMockup>(find.byType(SitePhoneMockup))
        .toList();

    expect(mockups, hasLength(1));
    expect(mockups.single.screenshot, card.project.screenshot);
  });

  testWidgets('em tela estreita o destaque esconde os mockups', (tester) async {
    await pumpSite(tester, const Size(600, 1200));

    expect(find.byType(SiteFeaturedProject), findsOneWidget);
    expect(find.byType(SitePhoneMockup), findsNothing);
  });
}
