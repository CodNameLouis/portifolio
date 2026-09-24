import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class NavDestination {
  const NavDestination({required this.label, required this.icon});

  final String label;
  final AppIconType icon;

  static const List<NavDestination> all = [
    NavDestination(label: AppStrings.navHome, icon: AppIconType.home),
    NavDestination(label: AppStrings.navProjects, icon: AppIconType.grid),
    NavDestination(label: AppStrings.navStack, icon: AppIconType.layers),
    NavDestination(label: AppStrings.navTrajectory, icon: AppIconType.route),
    NavDestination(label: AppStrings.navContact, icon: AppIconType.message),
  ];
}
