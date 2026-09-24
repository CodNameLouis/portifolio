import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_theme.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_bloc.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_event.dart';
import 'package:portfolio_luan/features/trajectory/models/education_model.dart';
import 'package:portfolio_luan/features/trajectory/models/experience_model.dart';
import 'package:portfolio_luan/features/trajectory/models/trajectory_model.dart';
import 'package:portfolio_luan/features/trajectory/repositories/trajectory_repository.dart';
import 'package:portfolio_luan/features/trajectory/views/trajectory_page.dart';
import 'package:portfolio_luan/features/trajectory/views/widgets/education_card.dart';
import 'package:portfolio_luan/features/trajectory/views/widgets/timeline_dot.dart';
import 'package:portfolio_luan/features/trajectory/views/widgets/timeline_item.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';

class _MockTrajectoryRepository extends Mock implements TrajectoryRepository {}

void main() {
  late _MockTrajectoryRepository repository;

  const atual = ExperienceModel(
    period: 'mai 2022 — atual',
    role: 'Flutter Pleno/Sênior & Gerente de Projetos',
    company: 'Strawti',
    mode: 'Remoto',
    description: 'Arquitetura, testes, CI/CD e publicação nas lojas.',
    current: true,
  );
  const anterior = ExperienceModel(
    period: '2014 — 2022',
    role: 'Técnico de TI & Telecom',
    company: 'AFC Informática',
    mode: 'Freelancer',
    description: 'Redes, infraestrutura e suporte direto ao cliente.',
    current: false,
  );

  const trajectory = TrajectoryModel(
    experiences: [atual, anterior],
    education: [
      EducationModel(course: 'Flutter & Dart', detail: 'Especialização online'),
    ],
  );

  setUp(() {
    repository = _MockTrajectoryRepository();
    when(repository.fetch).thenAnswer((_) async => trajectory);
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: BlocProvider(
            create: (context) =>
                TrajectoryBloc(repository: repository)
                  ..add(const TrajectoryStarted()),
            child: const TrajectoryPage(),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  BoxDecoration dotDecoration(WidgetTester tester, int index) {
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(TimelineDot).at(index),
            matching: find.byType(Container),
          )
          .first,
    );

    return container.decoration! as BoxDecoration;
  }

  testWidgets('mostra título, experiências e formação', (tester) async {
    await pumpPage(tester);

    expect(find.text(AppStrings.trajectoryTitle), findsOneWidget);
    expect(find.text(AppStrings.trajectorySubtitle), findsOneWidget);

    expect(find.byType(TimelineItem), findsNWidgets(2));
    expect(find.text(atual.role), findsOneWidget);
    expect(find.text(anterior.role), findsOneWidget);
    expect(find.text(atual.period), findsOneWidget);
    expect(
      find.text('${atual.company}${AppStrings.separator}${atual.mode}'),
      findsOneWidget,
    );

    expect(find.byType(EducationCard), findsOneWidget);
    expect(find.text(AppStrings.trajectoryEducationTitle), findsOneWidget);
    expect(
      find.text('Flutter & Dart${AppStrings.separator}Especialização online'),
      findsOneWidget,
    );
  });

  testWidgets('dot atual é terracota com halo; o anterior é anel mostarda', (
    tester,
  ) async {
    await pumpPage(tester);

    final atualDot = dotDecoration(tester, 0);
    expect(atualDot.color, AppColors.terracotta);
    expect(atualDot.border, isNull);
    expect(atualDot.boxShadow, hasLength(1));
    expect(atualDot.boxShadow!.single.color, AppColors.terracottaAlpha30);
    expect(atualDot.boxShadow!.single.spreadRadius, AppSizes.timelineDotHalo);

    final anteriorDot = dotDecoration(tester, 1);
    expect(anteriorDot.color, AppColors.navy);
    expect(anteriorDot.boxShadow, anyOf(isNull, isEmpty));
    expect((anteriorDot.border! as Border).top.color, AppColors.mustard);
  });

  testWidgets('a linha vertical não aparece no último item', (tester) async {
    await pumpPage(tester);

    final linhas = find.byWidgetPredicate(
      (widget) =>
          widget is ColoredBox && widget.color == AppColors.mustardAlpha35,
    );

    expect(linhas, findsOneWidget);

    final primeiro = tester.getRect(find.byType(TimelineItem).at(0));
    final linha = tester.getRect(linhas);

    expect(linha.top, greaterThanOrEqualTo(primeiro.top));
    expect(linha.bottom, lessThanOrEqualTo(primeiro.bottom + 1));
  });

  testWidgets('sem formação, o card não aparece', (tester) async {
    when(repository.fetch).thenAnswer(
      (_) async => const TrajectoryModel(experiences: [atual], education: []),
    );

    await pumpPage(tester);

    expect(find.byType(EducationCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mostra ErrorView quando o repositório falha', (tester) async {
    when(repository.fetch).thenThrow(const AppFailure.load());

    await pumpPage(tester);

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text(AppStrings.failureLoad), findsOneWidget);
  });
}
