import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/features/projects/models/project_category.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';

void main() {
  test('lê todos os campos de um JSON completo', () {
    final project = ProjectModel.fromJson(const {
      'id': 'stive_maps',
      'name': 'Stive Maps',
      'client': 'Stive Maps',
      'summary': 'Extensão da memória do policial.',
      'roles': ['PO', 'Desenvolvimento'],
      'tags': ['Geolocalização', 'Filtros'],
      'categories': ['maps'],
      'featured': true,
      'rating': 4.8,
      'ratingCount': 37,
      'thumbColor': 'navy',
      'icon': 'assets/images/projects/stive_maps_icon.png',
      'screenshot': 'assets/images/projects/stive_maps_screen.png',
      'url': 'https://apps.apple.com/br/app/stive-maps/id6499552890',
    });

    expect(project.name, 'Stive Maps');
    expect(project.roles, ['PO', 'Desenvolvimento']);
    expect(project.categories, [ProjectCategory.maps]);
    expect(project.featured, isTrue);
    expect(project.rating, 4.8);
    expect(project.ratingCount, 37);
    expect(project.thumbColor, AppColors.navy);
  });

  test('usa vazios quando os campos faltam', () {
    final project = ProjectModel.fromJson(const {});

    expect(project.id, isEmpty);
    expect(project.roles, isEmpty);
    expect(project.categories, isEmpty);
    expect(project.featured, isFalse);
    expect(project.rating, 0);
    expect(project.thumbColor, AppColors.navy);
  });

  test('converte o token de cor e cai em navy quando não reconhece', () {
    expect(ProjectModel.colorFromToken('mustard'), AppColors.mustard);
    expect(ProjectModel.colorFromToken('terracotta'), AppColors.terracotta);
    expect(ProjectModel.colorFromToken('roxo'), AppColors.navy);
    expect(ProjectModel.colorFromToken(null), AppColors.navy);
  });

  test('descarta categorias desconhecidas', () {
    final project = ProjectModel.fromJson(const {
      'categories': ['maps', 'astrologia', 'games'],
    });

    expect(project.categories, [ProjectCategory.maps, ProjectCategory.games]);
  });

  test('matches aceita tudo em "Todos" e só a própria categoria', () {
    final project = ProjectModel.fromJson(const {
      'categories': ['payments'],
    });

    expect(project.matches(ProjectCategory.all), isTrue);
    expect(project.matches(ProjectCategory.payments), isTrue);
    expect(project.matches(ProjectCategory.games), isFalse);
  });
}
