import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/services/link_launcher.dart';

class _MockUrlOpener extends Mock implements UrlOpener {}

void main() {
  late _MockUrlOpener opener;
  late LinkLauncher launcher;

  const url = 'https://apps.apple.com/app/stive-maps';

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://exemplo.com'));
  });

  setUp(() {
    opener = _MockUrlOpener();
    launcher = LinkLauncher(opener: opener);
  });

  test('devolve true quando o link abre', () async {
    when(() => opener.open(any())).thenAnswer((_) async => true);

    final result = await launcher.open(url);

    expect(result, isTrue);
    verify(() => opener.open(Uri.parse(url))).called(1);
  });

  test('devolve false quando o sistema recusa o link', () async {
    when(() => opener.open(any())).thenAnswer((_) async => false);

    expect(await launcher.open(url), isFalse);
  });

  test('devolve false quando o opener lança', () async {
    when(() => opener.open(any())).thenThrow(Exception('sem app disponível'));

    expect(await launcher.open(url), isFalse);
  });

  test('devolve false para URL sem esquema, sem chamar o opener', () async {
    expect(await launcher.open('apps.apple.com/app'), isFalse);
    verifyNever(() => opener.open(any()));
  });
}
