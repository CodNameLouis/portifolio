import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/link_launcher.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_theme.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_bloc.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_event.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';
import 'package:portfolio_luan/features/projects/repositories/projects_repository.dart';
import 'package:portfolio_luan/features/projects/views/projects_page.dart';
import 'package:portfolio_luan/features/projects/views/widgets/featured_project_card.dart';
import 'package:portfolio_luan/features/projects/views/widgets/project_list_tile.dart';

class _MockProjectsRepository extends Mock implements ProjectsRepository {}

class _MockLinkLauncher extends Mock implements LinkLauncher {}

ProjectModel _project({
  required String id,
  required String name,
  required List<String> categories,
  bool featured = false,
  List<String> roles = const ['PO', 'Desenvolvimento'],
  List<String> tags = const ['Flutter', 'BLoC'],
}) {
  return ProjectModel.fromJson({
    'id': id,
    'name': name,
    'summary': 'Resumo de $name.',
    'roles': roles,
    'tags': tags,
    'categories': categories,
    'featured': featured,
    'thumbColor': 'navy',
    'icon': 'assets/images/projects/${id}_icon.png',
    'screenshot': 'assets/images/projects/${id}_screen.png',
    'url': 'https://apps.apple.com/br/app/$id',
  });
}

void main() {
  late _MockProjectsRepository repository;
  late _MockLinkLauncher linkLauncher;

  final maps = _project(
    id: 'stive_maps',
    name: 'Stive Maps',
    categories: ['maps'],
    featured: true,
    roles: ['PO', 'QA'],
  );
  final games = _project(
    id: 'casedoku',
    name: 'Casedoku',
    categories: ['games'],
    tags: ['Jogo', 'Offline'],
  );

  setUp(() {
    repository = _MockProjectsRepository();
    linkLauncher = _MockLinkLauncher();
    when(repository.fetchAll).thenAnswer((_) async => [maps, games]);
    when(() => linkLauncher.open(any())).thenAnswer((_) async => true);
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
                ProjectsBloc(repository: repository, linkLauncher: linkLauncher)
                  ..add(const ProjectsStarted()),
            child: const ProjectsPage(),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('separa o destaque da lista', (tester) async {
    await pumpPage(tester);

    final card = tester.widget<FeaturedProjectCard>(
      find.byType(FeaturedProjectCard),
    );
    expect(card.project, maps);

    final tiles = tester
        .widgetList<ProjectListTile>(find.byType(ProjectListTile))
        .toList();
    expect(tiles.map((tile) => tile.project), [games]);
  });

  testWidgets('destaque mostra roles e item da lista mostra tags', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text(maps.roles.join(AppStrings.separator)), findsOneWidget);
    expect(find.text(games.tags.join(AppStrings.separator)), findsOneWidget);
  });

  testWidgets('filtrar por Jogos tira o destaque e deixa só o jogo', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.ensureVisible(find.text(AppStrings.categoryGames));
    await tester.pump();
    await tester.tap(find.text(AppStrings.categoryGames));
    await tester.pump();

    expect(find.byType(FeaturedProjectCard), findsNothing);

    final tiles = tester
        .widgetList<ProjectListTile>(find.byType(ProjectListTile))
        .toList();
    expect(tiles.map((tile) => tile.project), [games]);
  });

  testWidgets('o card de destaque cresce em vez de cortar o texto', (
    tester,
  ) async {
    final longo = _project(
      id: 'casedoku',
      name: 'Casedoku',
      categories: ['games'],
      featured: true,
      roles: ['Idealizador', 'PO', 'Desenvolvimento', 'QA', 'Deploy'],
    );
    when(repository.fetchAll).thenAnswer((_) async => [longo]);

    await pumpPage(tester);

    final roles = longo.roles.join(AppStrings.separator);
    final cardRect = tester.getRect(find.byType(FeaturedProjectCard));
    final rolesRect = tester.getRect(find.text(roles));

    expect(cardRect.height, greaterThan(AppSizes.featuredCard));
    expect(rolesRect.bottom, lessThanOrEqualTo(cardRect.bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets('tocar no item abre o link da loja', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text(games.name));
    await tester.pump();

    verify(() => linkLauncher.open(games.url)).called(1);
  });

  testWidgets('mostra SnackBar quando o link não abre', (tester) async {
    when(() => linkLauncher.open(any())).thenAnswer((_) async => false);

    await pumpPage(tester);

    await tester.tap(find.text(games.name));
    await tester.pump();
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(AppStrings.failureLink), findsOneWidget);
  });

  testWidgets('imagem ausente não quebra a tela', (tester) async {
    final semImagem = _project(
      id: 'inexistente',
      name: 'Sem imagem',
      categories: ['games'],
    );
    when(repository.fetchAll).thenAnswer((_) async => [maps, semImagem]);

    await pumpPage(tester);
    await tester.pump();

    expect(find.text('Sem imagem'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mostra ErrorView quando o repositório falha', (tester) async {
    when(repository.fetchAll).thenThrow(const AppFailure.load());

    await pumpPage(tester);

    expect(find.text(AppStrings.failureLoad), findsOneWidget);
  });
}
