import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_luan/core/constants/app_assets.dart';

class FakeAssetBundle extends CachingAssetBundle {
  FakeAssetBundle({Map<String, String>? files})
    : files = files ?? defaultFiles();

  final Map<String, String> files;

  static Map<String, String> defaultFiles() => {
    AppAssets.profileJson: jsonEncode(const {
      'firstName': 'Luan Nunes',
      'lastName': 'Caldeira',
      'greeting': 'Olá, eu sou',
      'role': 'Desenvolvedor Flutter Pleno/Sênior',
      'bio': 'Crio e evoluo apps mobile.',
      'available': true,
      'availabilityLabel': 'Disponível agora',
      'photo': 'assets/images/profile.jpg',
      'stats': [
        {
          'title': '4+ anos',
          'subtitle': 'com Flutter & Dart',
          'emphasis': true,
        },
      ],
    }),
    AppAssets.projectsJson: jsonEncode(const {
      'projects': [
        {
          'id': 'stive_maps',
          'name': 'Stive Maps',
          'client': 'Stive Maps',
          'summary': 'Extensão da memória do policial.',
          'roles': ['PO', 'Desenvolvimento'],
          'tags': ['Geolocalização', 'Filtros'],
          'categories': ['maps'],
          'featured': true,
          'thumbColor': 'navy',
          'icon': 'assets/images/projects/stive_maps_icon.png',
          'screenshot': 'assets/images/projects/stive_maps_screen.png',
          'url': 'https://apps.apple.com/br/app/stive-maps/id6499552890',
        },
        {
          'id': 'casedoku',
          'name': 'Casedoku',
          'client': 'Lumily',
          'summary': 'Jogo de lógica offline.',
          'roles': ['Idealizador', 'Desenvolvimento'],
          'tags': ['Jogo', 'Offline'],
          'categories': ['games'],
          'featured': false,
          'thumbColor': 'mustard',
          'icon': 'assets/images/projects/casedoku_icon.png',
          'screenshot': 'assets/images/projects/casedoku_screen.png',
          'url': 'https://apps.apple.com/br/app/casedoku/id6504005200',
        },
      ],
    }),
    AppAssets.stackJson: jsonEncode(const {
      'highlight': {
        'title': 'Flutter & Dart',
        'subtitle': 'iOS & Android · código nativo via Channels',
        'level': 'Especialista',
      },
      'groups': [
        {
          'label': 'Estado',
          'items': ['BLoC / Cubit', 'GetX'],
        },
        {
          'label': 'Nativo',
          'items': ['Kotlin', 'Swift'],
        },
      ],
    }),
    AppAssets.trajectoryJson: jsonEncode(const {
      'experiences': [
        {
          'period': 'mai 2022 — atual',
          'role': 'Flutter Pleno/Sênior & Gerente de Projetos',
          'company': 'Strawti',
          'mode': 'Remoto',
          'description': 'Arquitetura, testes, CI/CD e publicação nas lojas.',
          'current': true,
        },
        {
          'period': '2014 — 2022',
          'role': 'Técnico de TI & Telecom',
          'company': 'AFC Informática',
          'mode': 'Freelancer',
          'description': 'Redes, infraestrutura e suporte ao cliente.',
          'current': false,
        },
      ],
      'education': [
        {'course': 'Flutter & Dart', 'detail': 'Especialização online'},
      ],
    }),
    AppAssets.contactJson: jsonEncode(const {
      'title': 'Vamos tirar seu app do papel?',
      'subtitle': 'Disponibilidade imediata · 100% remoto',
      'links': [
        {
          'type': 'email',
          'label': 'E-mail',
          'value': 'luan@afcinfotelecom.net',
          'url': 'mailto:luan@afcinfotelecom.net',
        },
        {
          'type': 'github',
          'label': 'GitHub',
          'value': 'CodNameLouis',
          'url': 'https://github.com/CodNameLouis',
        },
      ],
      'resumeUrl': 'https://exemplo.com/curriculo_luan_nunes.pdf',
    }),
  };

  @override
  Future<ByteData> load(String key) async {
    final content = files[key];

    if (content == null) {
      throw FlutterError('asset ausente no FakeAssetBundle: $key');
    }

    return ByteData.sublistView(utf8.encode(content));
  }
}
