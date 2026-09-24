import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_bloc.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_event.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_state.dart';
import 'package:portfolio_luan/features/stack/models/skill_group_model.dart';
import 'package:portfolio_luan/features/stack/models/stack_highlight_model.dart';
import 'package:portfolio_luan/features/stack/models/stack_model.dart';
import 'package:portfolio_luan/features/stack/repositories/stack_repository.dart';

class _MockStackRepository extends Mock implements StackRepository {}

void main() {
  late _MockStackRepository repository;

  const stack = StackModel(
    highlight: StackHighlightModel(
      title: 'Flutter & Dart',
      subtitle: 'iOS & Android',
      level: 'Especialista',
    ),
    groups: [
      SkillGroupModel(label: 'Estado', items: ['BLoC / Cubit']),
    ],
  );

  setUp(() {
    repository = _MockStackRepository();
  });

  blocTest<StackBloc, StackState>(
    'emite Loading e Loaded quando o repositório responde',
    setUp: () {
      when(repository.fetch).thenAnswer((_) async => stack);
    },
    build: () => StackBloc(repository: repository),
    act: (bloc) => bloc.add(const StackStarted()),
    expect: () => const [StackLoading(), StackLoaded(stack)],
  );

  blocTest<StackBloc, StackState>(
    'emite Failure quando o repositório falha',
    setUp: () {
      when(repository.fetch).thenThrow(const AppFailure.parse());
    },
    build: () => StackBloc(repository: repository),
    act: (bloc) => bloc.add(const StackStarted()),
    expect: () => const [StackLoading(), StackFailure(AppFailure.parse())],
  );

  blocTest<StackBloc, StackState>(
    'converte erro inesperado em AppFailure.load',
    setUp: () {
      when(repository.fetch).thenThrow(Exception('erro qualquer'));
    },
    build: () => StackBloc(repository: repository),
    act: (bloc) => bloc.add(const StackStarted()),
    expect: () => const [StackLoading(), StackFailure(AppFailure.load())],
  );
}
