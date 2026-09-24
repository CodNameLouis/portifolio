import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_theme.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_bloc.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_event.dart';
import 'package:portfolio_luan/features/stack/models/skill_group_model.dart';
import 'package:portfolio_luan/features/stack/models/stack_highlight_model.dart';
import 'package:portfolio_luan/features/stack/models/stack_model.dart';
import 'package:portfolio_luan/features/stack/repositories/stack_repository.dart';
import 'package:portfolio_luan/features/stack/views/stack_page.dart';
import 'package:portfolio_luan/features/stack/views/widgets/skill_group_row.dart';
import 'package:portfolio_luan/features/stack/views/widgets/stack_highlight_card.dart';
import 'package:portfolio_luan/shared/widgets/chips/badge_pill.dart';
import 'package:portfolio_luan/shared/widgets/chips/tag_chip.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';

class _MockStackRepository extends Mock implements StackRepository {}

void main() {
  late _MockStackRepository repository;

  const stack = StackModel(
    highlight: StackHighlightModel(
      title: 'Flutter & Dart',
      subtitle: 'iOS & Android · código nativo via Channels',
      level: 'Especialista',
    ),
    groups: [
      SkillGroupModel(label: 'Estado', items: ['BLoC / Cubit', 'GetX']),
      SkillGroupModel(label: 'Nativo', items: ['Kotlin', 'Swift']),
    ],
  );

  setUp(() {
    repository = _MockStackRepository();
    when(repository.fetch).thenAnswer((_) async => stack);
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
                StackBloc(repository: repository)..add(const StackStarted()),
            child: const StackPage(),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('mostra título, destaque e grupos', (tester) async {
    await pumpPage(tester);

    expect(find.text(AppStrings.stackTitle), findsOneWidget);
    expect(find.text(AppStrings.stackSubtitle), findsOneWidget);

    expect(find.byType(StackHighlightCard), findsOneWidget);
    expect(find.text('Flutter & Dart'), findsOneWidget);
    expect(
      find.text('iOS & Android · código nativo via Channels'),
      findsOneWidget,
    );

    final badge = tester.widget<BadgePill>(find.byType(BadgePill));
    expect(badge.label, 'Especialista');

    expect(find.byType(SkillGroupRow), findsNWidgets(2));
    expect(find.text('Estado'), findsOneWidget);
    expect(find.text('Nativo'), findsOneWidget);
    expect(find.byType(TagChip), findsNWidgets(4));
    expect(find.text('BLoC / Cubit'), findsOneWidget);
    expect(find.text('Kotlin'), findsOneWidget);
  });

  testWidgets('rótulo longo não quebra em duas linhas', (tester) async {
    when(repository.fetch).thenAnswer(
      (_) async => const StackModel(
        highlight: null,
        groups: [
          SkillGroupModel(label: 'Estado', items: ['BLoC / Cubit']),
          SkillGroupModel(label: 'Monitoramento', items: ['Crashlytics']),
        ],
      ),
    );

    await pumpPage(tester);

    final curto = tester.getSize(find.text('Estado'));
    final longo = tester.getSize(find.text('Monitoramento'));

    expect(longo.height, curto.height);
    expect(longo.height, lessThan(AppTypography.captionStrong.fontSize! * 2));
  });

  testWidgets('todos os grupos usam a mesma largura de rótulo', (tester) async {
    when(repository.fetch).thenAnswer(
      (_) async => const StackModel(
        highlight: null,
        groups: [
          SkillGroupModel(label: 'Estado', items: ['BLoC / Cubit']),
          SkillGroupModel(label: 'Monitoramento', items: ['Crashlytics']),
          SkillGroupModel(label: 'CI/CD', items: ['Fastlane']),
        ],
      ),
    );

    await pumpPage(tester);

    final larguras = tester
        .widgetList<SkillGroupRow>(find.byType(SkillGroupRow))
        .map((row) => row.labelWidth)
        .toSet();

    expect(larguras, hasLength(1));
    expect(larguras.single, greaterThanOrEqualTo(AppSizes.skillGroupLabel));

    final inicios = tester
        .widgetList<TagChip>(find.byType(TagChip))
        .map((chip) => tester.getTopLeft(find.byWidget(chip)).dx)
        .toSet();

    expect(inicios, hasLength(1));
  });

  testWidgets('o card de destaque usa fundo navy', (tester) async {
    await pumpPage(tester);

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(StackHighlightCard),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;

    expect(decoration.color, AppColors.navy);
  });

  testWidgets('sem highlight, a tela mostra só os grupos', (tester) async {
    when(repository.fetch).thenAnswer(
      (_) async => const StackModel(
        highlight: null,
        groups: [
          SkillGroupModel(label: 'Estado', items: ['BLoC / Cubit']),
        ],
      ),
    );

    await pumpPage(tester);

    expect(find.byType(StackHighlightCard), findsNothing);
    expect(find.byType(SkillGroupRow), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mostra ErrorView quando o repositório falha', (tester) async {
    when(repository.fetch).thenThrow(const AppFailure.load());

    await pumpPage(tester);

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text(AppStrings.failureLoad), findsOneWidget);
  });
}
