import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_bloc.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_event.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_state.dart';
import 'package:portfolio_luan/features/trajectory/models/education_model.dart';
import 'package:portfolio_luan/features/trajectory/models/experience_model.dart';
import 'package:portfolio_luan/features/trajectory/models/trajectory_model.dart';
import 'package:portfolio_luan/features/trajectory/repositories/trajectory_repository.dart';

class _MockTrajectoryRepository extends Mock implements TrajectoryRepository {}

void main() {
  late _MockTrajectoryRepository repository;

  const trajectory = TrajectoryModel(
    experiences: [
      ExperienceModel(
        period: 'mai 2022 — atual',
        role: 'Flutter Pleno/Sênior',
        company: 'Strawti',
        mode: 'Remoto',
        description: 'Arquitetura, testes e CI/CD.',
        current: true,
      ),
    ],
    education: [
      EducationModel(course: 'Flutter & Dart', detail: 'Especialização online'),
    ],
  );

  setUp(() {
    repository = _MockTrajectoryRepository();
  });

  blocTest<TrajectoryBloc, TrajectoryState>(
    'emite Loading e Loaded quando o repositório responde',
    setUp: () {
      when(repository.fetch).thenAnswer((_) async => trajectory);
    },
    build: () => TrajectoryBloc(repository: repository),
    act: (bloc) => bloc.add(const TrajectoryStarted()),
    expect: () => const [TrajectoryLoading(), TrajectoryLoaded(trajectory)],
  );

  blocTest<TrajectoryBloc, TrajectoryState>(
    'emite Failure quando o repositório falha',
    setUp: () {
      when(repository.fetch).thenThrow(const AppFailure.parse());
    },
    build: () => TrajectoryBloc(repository: repository),
    act: (bloc) => bloc.add(const TrajectoryStarted()),
    expect: () => const [
      TrajectoryLoading(),
      TrajectoryFailure(AppFailure.parse()),
    ],
  );

  blocTest<TrajectoryBloc, TrajectoryState>(
    'converte erro inesperado em AppFailure.load',
    setUp: () {
      when(repository.fetch).thenThrow(Exception('erro qualquer'));
    },
    build: () => TrajectoryBloc(repository: repository),
    act: (bloc) => bloc.add(const TrajectoryStarted()),
    expect: () => const [
      TrajectoryLoading(),
      TrajectoryFailure(AppFailure.load()),
    ],
  );
}
