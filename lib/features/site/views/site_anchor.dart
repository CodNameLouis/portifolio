import 'package:portfolio_luan/app/router/app_routes.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';

enum SiteAnchor {
  projects(AppStrings.navProjects, AppRoutes.projects),
  stack(AppStrings.navStack, AppRoutes.stack),
  trajectory(AppStrings.navTrajectory, AppRoutes.trajectory),
  contact(AppStrings.navContact, AppRoutes.contact);

  const SiteAnchor(this.label, this.path);

  final String label;
  final String path;

  static List<String> get labels => [for (final anchor in values) anchor.label];
}
