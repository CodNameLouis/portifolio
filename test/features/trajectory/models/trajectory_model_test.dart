import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/features/trajectory/models/trajectory_model.dart';

void main() {
  test('lê experiências e formação de um JSON completo', () {
    final trajectory = TrajectoryModel.fromJson(const {
      'experiences': [
        {
          'period': 'mai 2022 — atual',
          'role': 'Flutter Pleno/Sênior',
          'company': 'Strawti',
          'mode': 'Remoto',
          'description': 'Arquitetura, testes e CI/CD.',
          'current': true,
        },
        {
          'period': '2014 — 2022',
          'role': 'Técnico de TI',
          'company': 'AFC Informática',
          'mode': 'Freelancer',
          'description': 'Redes e infraestrutura.',
          'current': false,
        },
      ],
      'education': [
        {'course': 'Flutter & Dart', 'detail': 'Especialização online'},
      ],
    });

    expect(trajectory.experiences, hasLength(2));
    expect(trajectory.experiences.first.current, isTrue);
    expect(trajectory.experiences.last.company, 'AFC Informática');
    expect(trajectory.education.single.course, 'Flutter & Dart');
  });

  test('listas vazias quando os campos faltam', () {
    final trajectory = TrajectoryModel.fromJson(const {});

    expect(trajectory.experiences, isEmpty);
    expect(trajectory.education, isEmpty);
  });

  test('ignora entradas que não são objetos', () {
    final trajectory = TrajectoryModel.fromJson(const {
      'experiences': [
        {'role': 'Flutter'},
        'lixo',
      ],
      'education': [42],
    });

    expect(trajectory.experiences, hasLength(1));
    expect(trajectory.education, isEmpty);
  });

  test('current vira false quando o campo não vem', () {
    final trajectory = TrajectoryModel.fromJson(const {
      'experiences': [
        {'role': 'Flutter'},
      ],
    });

    expect(trajectory.experiences.single.current, isFalse);
  });
}
