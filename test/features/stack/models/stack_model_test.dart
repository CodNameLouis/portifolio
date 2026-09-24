import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/features/stack/models/stack_model.dart';

void main() {
  test('lê highlight e grupos de um JSON completo', () {
    final stack = StackModel.fromJson(const {
      'highlight': {
        'title': 'Flutter & Dart',
        'subtitle': 'iOS & Android',
        'level': 'Especialista',
      },
      'groups': [
        {
          'label': 'Estado',
          'items': ['BLoC / Cubit', 'GetX'],
        },
        {
          'label': 'Backend',
          'items': ['APIs REST'],
        },
      ],
    });

    expect(stack.highlight?.title, 'Flutter & Dart');
    expect(stack.highlight?.level, 'Especialista');
    expect(stack.groups, hasLength(2));
    expect(stack.groups.first.items, ['BLoC / Cubit', 'GetX']);
  });

  test('highlight vira null e grupos viram lista vazia sem os campos', () {
    final stack = StackModel.fromJson(const {});

    expect(stack.highlight, isNull);
    expect(stack.groups, isEmpty);
  });

  test('ignora itens e grupos que não têm o formato esperado', () {
    final stack = StackModel.fromJson(const {
      'groups': [
        {
          'label': 'Estado',
          'items': ['BLoC', 7, null],
        },
        'lixo',
      ],
    });

    expect(stack.groups, hasLength(1));
    expect(stack.groups.single.items, ['BLoC']);
  });

  test('dois models com os mesmos dados são iguais', () {
    const json = {
      'highlight': {'title': 'Flutter & Dart'},
      'groups': [
        {
          'label': 'Estado',
          'items': ['BLoC'],
        },
      ],
    };

    expect(StackModel.fromJson(json), StackModel.fromJson(json));
  });
}
