import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/stack/repositories/local_stack_repository.dart';

class _MockJsonAssetLoader extends Mock implements JsonAssetLoader {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockJsonAssetLoader loader;
  late LocalStackRepository repository;

  setUp(() {
    loader = _MockJsonAssetLoader();
    repository = LocalStackRepository(loader: loader);
  });

  test('lê o stack.json e devolve o model', () async {
    when(() => loader.load(AppAssets.stackJson)).thenAnswer(
      (_) async => const {
        'highlight': {'title': 'Flutter & Dart', 'level': 'Especialista'},
        'groups': [
          {
            'label': 'Estado',
            'items': ['BLoC / Cubit'],
          },
        ],
      },
    );

    final stack = await repository.fetch();

    expect(stack.highlight?.title, 'Flutter & Dart');
    expect(stack.groups, hasLength(1));
  });

  test('propaga a falha do loader', () async {
    when(
      () => loader.load(AppAssets.stackJson),
    ).thenThrow(const AppFailure.load());

    expect(repository.fetch, throwsA(const AppFailure.load()));
  });

  test('o stack.json do app tem o destaque e os 9 grupos', () async {
    final real = LocalStackRepository(
      loader: JsonAssetLoader(bundle: rootBundle),
    );

    final stack = await real.fetch();

    expect(stack.highlight?.title, 'Flutter & Dart');
    expect(stack.highlight?.level, isNotEmpty);
    expect(stack.groups, hasLength(9));

    for (final group in stack.groups) {
      expect(group.label, isNotEmpty);
      expect(group.items, isNotEmpty);
    }

    final labels = stack.groups.map((group) => group.label);
    expect(labels, containsAll(['Monitoramento', 'Nativo', 'Métodos']));
  });
}
