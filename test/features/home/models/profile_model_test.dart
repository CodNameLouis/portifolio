import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/features/home/models/profile_model.dart';

void main() {
  test('lê todos os campos de um JSON completo', () {
    final profile = ProfileModel.fromJson(const {
      'firstName': 'Luan Nunes',
      'lastName': 'Caldeira',
      'greeting': 'Olá, eu sou',
      'role': 'Desenvolvedor Flutter Pleno/Sênior',
      'bio': 'Crio apps mobile.',
      'available': true,
      'availabilityLabel': 'Disponível agora',
      'photo': 'assets/images/profile.jpg',
      'stats': [
        {
          'title': '4+ anos',
          'subtitle': 'com Flutter & Dart',
          'emphasis': true,
        },
        {'title': 'Campina Grande, PB', 'subtitle': '100% remoto'},
      ],
    });

    expect(profile.firstName, 'Luan Nunes');
    expect(profile.lastName, 'Caldeira');
    expect(profile.available, isTrue);
    expect(profile.stats, hasLength(2));
    expect(profile.stats.first.emphasis, isTrue);
    expect(profile.stats.last.emphasis, isFalse);
  });

  test('usa vazios quando os campos faltam', () {
    final profile = ProfileModel.fromJson(const {});

    expect(profile.firstName, isEmpty);
    expect(profile.bio, isEmpty);
    expect(profile.available, isFalse);
    expect(profile.stats, isEmpty);
  });

  test('ignora entradas de stats que não são objetos', () {
    final profile = ProfileModel.fromJson(const {
      'stats': [
        {'title': '4+ anos'},
        'lixo',
        42,
      ],
    });

    expect(profile.stats, hasLength(1));
    expect(profile.stats.single.title, '4+ anos');
  });

  test('duas instâncias com os mesmos dados são iguais', () {
    const json = {
      'firstName': 'Luan Nunes',
      'stats': [
        {
          'title': '4+ anos',
          'subtitle': 'com Flutter & Dart',
          'emphasis': true,
        },
      ],
    };

    expect(ProfileModel.fromJson(json), ProfileModel.fromJson(json));
  });
}
