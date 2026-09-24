import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/home/repositories/local_profile_repository.dart';

class _MockJsonAssetLoader extends Mock implements JsonAssetLoader {}

void main() {
  late _MockJsonAssetLoader loader;
  late LocalProfileRepository repository;

  setUp(() {
    loader = _MockJsonAssetLoader();
    repository = LocalProfileRepository(loader: loader);
  });

  test('lê o profile.json e devolve o model', () async {
    when(() => loader.load(AppAssets.profileJson)).thenAnswer(
      (_) async => const {
        'firstName': 'Luan Nunes',
        'lastName': 'Caldeira',
        'available': true,
        'stats': [
          {'title': '4+ anos', 'subtitle': 'com Flutter & Dart'},
        ],
      },
    );

    final profile = await repository.fetch();

    expect(profile.firstName, 'Luan Nunes');
    expect(profile.stats, hasLength(1));
    verify(() => loader.load(AppAssets.profileJson)).called(1);
  });

  test('propaga a falha do loader', () async {
    when(
      () => loader.load(AppAssets.profileJson),
    ).thenThrow(const AppFailure.load());

    expect(repository.fetch, throwsA(const AppFailure.load()));
  });

  test('vira AppFailure.parse quando o JSON tem tipo errado', () async {
    when(
      () => loader.load(AppAssets.profileJson),
    ).thenAnswer((_) async => const {'firstName': 42});

    expect(repository.fetch, throwsA(const AppFailure.parse()));
  });
}
