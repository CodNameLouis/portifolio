import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_type.dart';
import 'package:portfolio_luan/features/contact/repositories/local_contact_repository.dart';

class _MockJsonAssetLoader extends Mock implements JsonAssetLoader {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockJsonAssetLoader loader;
  late LocalContactRepository repository;

  setUp(() {
    loader = _MockJsonAssetLoader();
    repository = LocalContactRepository(loader: loader);
  });

  test('lê o contact.json e devolve o model', () async {
    when(() => loader.load(AppAssets.contactJson)).thenAnswer(
      (_) async => const {
        'title': 'Vamos tirar seu app do papel?',
        'links': [
          {'type': 'email', 'value': 'luan@afcinfotelecom.net'},
        ],
        'resumeUrl': 'https://exemplo.com/curriculo.pdf',
      },
    );

    final contact = await repository.fetch();

    expect(contact.links.single.type, ContactLinkType.email);
  });

  test('propaga a falha do loader', () async {
    when(
      () => loader.load(AppAssets.contactJson),
    ).thenThrow(const AppFailure.load());

    expect(repository.fetch, throwsA(const AppFailure.load()));
  });

  test('o contact.json do app tem os 4 links e URLs válidas', () async {
    final real = LocalContactRepository(
      loader: JsonAssetLoader(bundle: rootBundle),
    );

    final contact = await real.fetch();

    expect(contact.title, isNotEmpty);
    expect(contact.subtitle, isNotEmpty);
    expect(contact.resumeUrl, startsWith('https://'));
    expect(contact.links, hasLength(4));
    expect(contact.links.map((link) => link.type), ContactLinkType.values);

    for (final link in contact.links) {
      expect(link.label, isNotEmpty);
      expect(link.value, isNotEmpty);
      expect(Uri.parse(link.url).hasScheme, isTrue);
    }

    final email = contact.links.first;
    expect(email.url, 'mailto:${email.value}');
  });
}
