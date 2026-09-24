import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/projects/models/project_category.dart';
import 'package:portfolio_luan/features/projects/repositories/local_projects_repository.dart';

class _MockJsonAssetLoader extends Mock implements JsonAssetLoader {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockJsonAssetLoader loader;
  late LocalProjectsRepository repository;

  setUp(() {
    loader = _MockJsonAssetLoader();
    repository = LocalProjectsRepository(loader: loader);
  });

  test('lê a lista de projetos', () async {
    when(() => loader.load(AppAssets.projectsJson)).thenAnswer(
      (_) async => const {
        'projects': [
          {'id': 'stive_maps', 'name': 'Stive Maps'},
          {'id': 'casedoku', 'name': 'Casedoku'},
        ],
      },
    );

    final projects = await repository.fetchAll();

    expect(projects, hasLength(2));
    expect(projects.first.name, 'Stive Maps');
  });

  test('devolve lista vazia quando a chave projects não existe', () async {
    when(
      () => loader.load(AppAssets.projectsJson),
    ).thenAnswer((_) async => const {});

    expect(await repository.fetchAll(), isEmpty);
  });

  test('propaga a falha do loader', () async {
    when(
      () => loader.load(AppAssets.projectsJson),
    ).thenThrow(const AppFailure.load());

    expect(repository.fetchAll, throwsA(const AppFailure.load()));
  });

  test('o projects.json do app tem os 7 apps e um único destaque', () async {
    final real = LocalProjectsRepository(
      loader: JsonAssetLoader(bundle: rootBundle),
    );

    final projects = await real.fetchAll();

    expect(projects, hasLength(7));
    expect(projects.where((project) => project.featured), hasLength(1));

    for (final project in projects) {
      expect(project.id, isNotEmpty);
      expect(project.name, isNotEmpty);
      expect(project.url, startsWith('https://'));
      expect(project.roles, isNotEmpty);
      expect(project.tags, isNotEmpty);
      expect(project.categories, isNotEmpty);
      expect(project.categories, isNot(contains(ProjectCategory.all)));
    }
  });
}
