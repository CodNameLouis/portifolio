import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/link_launcher.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_bloc.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_event.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_state.dart';
import 'package:portfolio_luan/features/projects/models/project_category.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';
import 'package:portfolio_luan/features/projects/repositories/projects_repository.dart';

class _MockProjectsRepository extends Mock implements ProjectsRepository {}

class _MockLinkLauncher extends Mock implements LinkLauncher {}

ProjectModel _project({
  required String id,
  required List<String> categories,
  bool featured = false,
}) {
  return ProjectModel.fromJson({
    'id': id,
    'name': id,
    'categories': categories,
    'featured': featured,
    'url': 'https://apps.apple.com/br/app/$id',
  });
}

void main() {
  late _MockProjectsRepository repository;
  late _MockLinkLauncher linkLauncher;

  final maps = _project(id: 'stive_maps', categories: ['maps'], featured: true);
  final payments = _project(id: 'flyphotos', categories: ['payments']);
  final games = _project(id: 'casedoku', categories: ['games']);
  final all = [maps, payments, games];

  setUp(() {
    repository = _MockProjectsRepository();
    linkLauncher = _MockLinkLauncher();
  });

  ProjectsBloc build() =>
      ProjectsBloc(repository: repository, linkLauncher: linkLauncher);

  blocTest<ProjectsBloc, ProjectsState>(
    'carrega os projetos com o filtro em Todos',
    setUp: () {
      when(repository.fetchAll).thenAnswer((_) async => all);
    },
    build: build,
    act: (bloc) => bloc.add(const ProjectsStarted()),
    expect: () => [const ProjectsLoading(), ProjectsLoaded(projects: all)],
    verify: (bloc) {
      final state = bloc.state as ProjectsLoaded;
      expect(state.selectedCategory, ProjectCategory.all);
      expect(state.featured, maps);
      expect(state.others, [payments, games]);
    },
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emite Failure quando o repositório falha',
    setUp: () {
      when(repository.fetchAll).thenThrow(const AppFailure.parse());
    },
    build: build,
    act: (bloc) => bloc.add(const ProjectsStarted()),
    expect: () => const [
      ProjectsLoading(),
      ProjectsFailure(AppFailure.parse()),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'filtra por categoria sem recarregar o repositório',
    setUp: () {
      when(repository.fetchAll).thenAnswer((_) async => all);
    },
    build: build,
    act: (bloc) => bloc
      ..add(const ProjectsStarted())
      ..add(const ProjectsFilterChanged(ProjectCategory.games)),
    skip: 2,
    expect: () => [
      ProjectsLoaded(projects: all, selectedCategory: ProjectCategory.games),
    ],
    verify: (bloc) {
      final state = bloc.state as ProjectsLoaded;
      expect(state.visible, [games]);
      expect(state.featured, isNull);
      expect(state.others, [games]);
      verify(repository.fetchAll).called(1);
    },
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'ignora o filtro antes dos dados chegarem',
    build: build,
    act: (bloc) => bloc.add(const ProjectsFilterChanged(ProjectCategory.maps)),
    expect: () => const <ProjectsState>[],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'abre o link do projeto e não muda de estado quando dá certo',
    setUp: () {
      when(repository.fetchAll).thenAnswer((_) async => all);
      when(() => linkLauncher.open(any())).thenAnswer((_) async => true);
    },
    build: build,
    act: (bloc) => bloc
      ..add(const ProjectsStarted())
      ..add(ProjectOpened(payments)),
    skip: 2,
    expect: () => const <ProjectsState>[],
    verify: (_) {
      verify(() => linkLauncher.open(payments.url)).called(1);
    },
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'marca launchFailure quando o link não abre',
    setUp: () {
      when(repository.fetchAll).thenAnswer((_) async => all);
      when(() => linkLauncher.open(any())).thenAnswer((_) async => false);
    },
    build: build,
    act: (bloc) => bloc
      ..add(const ProjectsStarted())
      ..add(ProjectOpened(payments)),
    skip: 2,
    expect: () => [
      ProjectsLoaded(projects: all, launchFailure: const AppFailure.link()),
    ],
  );
}
