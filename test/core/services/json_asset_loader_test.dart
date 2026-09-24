import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';

class _MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late _MockAssetBundle bundle;
  late JsonAssetLoader loader;

  const path = 'assets/data/profile.json';

  setUp(() {
    bundle = _MockAssetBundle();
    loader = JsonAssetLoader(bundle: bundle);
  });

  test('devolve o mapa decodificado quando o JSON é válido', () async {
    when(() => bundle.loadString(path)).thenAnswer(
      (_) async => '{"firstName":"Luan","stats":[{"title":"4+ anos"}]}',
    );

    final result = await loader.load(path);

    expect(result['firstName'], 'Luan');
    expect(result['stats'], isA<List<dynamic>>());
  });

  test('lança AppFailure.load quando o bundle falha', () async {
    when(() => bundle.loadString(path)).thenThrow(Exception('asset ausente'));

    expect(() => loader.load(path), throwsA(const AppFailure.load()));
  });

  test('lança AppFailure.parse quando o JSON é inválido', () async {
    when(() => bundle.loadString(path)).thenAnswer((_) async => 'não é json');

    expect(() => loader.load(path), throwsA(const AppFailure.parse()));
  });

  test('lança AppFailure.parse quando o JSON não é um objeto', () async {
    when(() => bundle.loadString(path)).thenAnswer((_) async => '[1,2,3]');

    expect(() => loader.load(path), throwsA(const AppFailure.parse()));
  });
}
