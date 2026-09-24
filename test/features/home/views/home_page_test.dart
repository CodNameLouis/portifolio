import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_theme.dart';
import 'package:portfolio_luan/features/home/controllers/home_bloc.dart';
import 'package:portfolio_luan/features/home/controllers/home_event.dart';
import 'package:portfolio_luan/features/home/models/highlight_stat_model.dart';
import 'package:portfolio_luan/features/home/models/profile_model.dart';
import 'package:portfolio_luan/features/home/repositories/profile_repository.dart';
import 'package:portfolio_luan/features/home/views/home_page.dart';
import 'package:portfolio_luan/features/home/views/widgets/profile_photo_card.dart';
import 'package:portfolio_luan/shared/widgets/chips/status_pill.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';
import 'package:portfolio_luan/shared/widgets/feedback/loading_view.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late _MockProfileRepository repository;

  const profile = ProfileModel(
    firstName: 'Luan Nunes',
    lastName: 'Caldeira',
    greeting: 'Olá, eu sou',
    role: 'Desenvolvedor Flutter Pleno/Sênior',
    bio: 'Crio e evoluo apps mobile.',
    available: true,
    availabilityLabel: 'Disponível agora',
    photo: 'assets/images/profile.jpg',
    stats: [
      HighlightStatModel(
        title: '4+ anos',
        subtitle: 'com Flutter & Dart',
        emphasis: true,
      ),
      HighlightStatModel(
        title: 'Campina Grande, PB',
        subtitle: '100% remoto',
        emphasis: false,
      ),
    ],
  );

  setUp(() {
    repository = _MockProfileRepository();
  });

  Future<void> pumpPage(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: BlocProvider(
            create: (context) =>
                HomeBloc(repository: repository)..add(const HomeStarted()),
            child: const HomePage(),
          ),
        ),
      ),
    );
  }

  testWidgets('mostra LoadingView enquanto o perfil carrega', (tester) async {
    when(repository.fetch).thenAnswer(
      (_) => Future.delayed(const Duration(milliseconds: 50), () => profile),
    );

    await pumpPage(tester);
    await tester.pump();

    expect(find.byType(LoadingView), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets('mostra o perfil carregado, com foto, pill e stats', (
    tester,
  ) async {
    when(repository.fetch).thenAnswer((_) async => profile);

    await pumpPage(tester);
    await tester.pumpAndSettle();

    expect(find.text(profile.greeting), findsOneWidget);
    expect(find.text(profile.bio), findsOneWidget);
    expect(find.byType(ProfilePhotoCard), findsOneWidget);

    final pill = tester.widget<StatusPill>(find.byType(StatusPill));
    expect(pill.label, profile.availabilityLabel);

    for (final stat in profile.stats) {
      expect(find.text(stat.title), findsOneWidget);
      expect(find.text(stat.subtitle), findsOneWidget);
    }

    expect(find.text(AppStrings.homeViewProjects), findsOneWidget);
    expect(find.text(AppStrings.homeContact), findsOneWidget);
  });

  testWidgets('escreve o sobrenome em terracotta', (tester) async {
    when(repository.fetch).thenAnswer((_) async => profile);

    await pumpPage(tester);
    await tester.pumpAndSettle();

    final name = tester.widget<RichText>(
      find.descendant(
        of: find.byType(HomePage),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains(profile.lastName),
        ),
      ),
    );

    final spans = <TextSpan>[];
    name.text.visitChildren((span) {
      if (span is TextSpan && span.text != null) {
        spans.add(span);
      }
      return true;
    });

    expect(name.text.toPlainText(), '${profile.firstName} ${profile.lastName}');
    expect(spans.map((span) => span.text), [
      '${profile.firstName} ',
      profile.lastName,
    ]);
    expect(spans.last.style?.color, AppColors.terracotta);
    expect(spans.first.style?.color, isNot(AppColors.terracotta));
  });

  testWidgets('esconde a StatusPill quando não está disponível', (
    tester,
  ) async {
    when(repository.fetch).thenAnswer(
      (_) async => const ProfileModel(
        firstName: 'Luan Nunes',
        lastName: 'Caldeira',
        greeting: 'Olá, eu sou',
        role: 'Desenvolvedor',
        bio: 'Bio.',
        available: false,
        availabilityLabel: 'Disponível agora',
        photo: 'assets/images/profile.jpg',
        stats: [],
      ),
    );

    await pumpPage(tester);
    await tester.pumpAndSettle();

    expect(find.byType(StatusPill), findsNothing);
  });

  testWidgets('mostra ErrorView e recarrega ao tocar em tentar de novo', (
    tester,
  ) async {
    when(repository.fetch).thenThrow(const AppFailure.load());

    await pumpPage(tester);
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text(AppStrings.failureLoad), findsOneWidget);

    when(repository.fetch).thenAnswer((_) async => profile);

    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsNothing);
    expect(find.text(profile.bio), findsOneWidget);
    verify(repository.fetch).called(2);
  });
}
