import 'package:portfolio_luan/core/constants/app_assets.dart';

enum AppIconType {
  home(AppAssets.homeIcon),
  grid(AppAssets.gridIcon),
  layers(AppAssets.layersIcon),
  route(AppAssets.routeIcon),
  message(AppAssets.messageIcon),
  arrowRight(AppAssets.arrowRightIcon),
  arrowUpRight(AppAssets.arrowUpRightIcon),
  download(AppAssets.downloadIcon);

  const AppIconType(this.path);

  final String path;
}
