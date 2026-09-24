import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/trajectory/repositories/local_trajectory_repository.dart';

class _MockJsonAssetLoader extends Mock implements JsonAssetLoader {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockJsonAssetLoader loader;
  late LocalTrajectoryRepository repository;

  setUp(() {
    loader = _MockJsonAssetLoader();
    repository = LocalTrajectoryRepository(loader: loader);
  });

  test('lê o trajectory.json e devolve o model', () async {
    when(() => loader.load(AppAssets.trajectoryJson)).thenAnswer(
      (_) async => const {
        'experiences': [
          {'role': 'Flutter Pleno/Sênior', 'current': true},
        ],
        'education': [
          {'course': 'Flutter & Dart'},
        ],
      },
    );

    final trajectory = await repository.fetch();

    expect(trajectory.experiences.single.current, isTrue);
    expect(trajectory.education, hasLength(1));
  });

  test('propaga a falha do loader', () async {
    when(
      () => loader.load(AppAssets.trajectoryJson),
    ).thenThrow(const AppFailure.load());

    expect(repository.fetch, throwsA(const AppFailure.load()));
  });

  test(
    'o trajectory.json do app vai do início da carreira até o atual',
    () async {
      final real = LocalTrajectoryRepository(
        loader: JsonAssetLoader(bundle: rootBundle),
      );

      final trajectory = await real.fetch();

      expect(trajectory.experiences, hasLength(3));
      expect(
        trajectory.experiences.where((experience) => experience.current),
        hasLength(1),
      );
      expect(
        trajectory.experiences.last.current,
        isTrue,
        reason: 'a linha do tempo vai do começo da carreira até o atual',
      );
      expect(trajectory.experiences.first.current, isFalse);
      expect(trajectory.experiences.first.period, startsWith('2014'));
      expect(trajectory.education, isNotEmpty);

      for (final experience in trajectory.experiences) {
        expect(experience.period, isNotEmpty);
        expect(experience.role, isNotEmpty);
        expect(experience.company, isNotEmpty);
        expect(experience.description, isNotEmpty);
      }
    },
  );
}
