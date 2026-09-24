import 'package:portfolio_luan/core/constants/app_strings.dart';

enum ProjectCategory {
  all(AppStrings.categoryAll, 'all'),
  maps(AppStrings.categoryMaps, 'maps'),
  payments(AppStrings.categoryPayments, 'payments'),
  management(AppStrings.categoryManagement, 'management'),
  games(AppStrings.categoryGames, 'games');

  const ProjectCategory(this.label, this.key);

  final String label;
  final String key;

  static ProjectCategory? fromKey(String key) {
    for (final category in values) {
      if (category.key == key) {
        return category;
      }
    }

    return null;
  }
}
