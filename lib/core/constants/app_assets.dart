abstract final class AppAssets {
  static const String profileJson = 'assets/data/profile.json';
  static const String projectsJson = 'assets/data/projects.json';
  static const String stackJson = 'assets/data/stack.json';
  static const String trajectoryJson = 'assets/data/trajectory.json';
  static const String contactJson = 'assets/data/contact.json';

  static const String homeIcon = 'assets/icons/home.svg';
  static const String gridIcon = 'assets/icons/grid.svg';
  static const String layersIcon = 'assets/icons/layers.svg';
  static const String routeIcon = 'assets/icons/route.svg';
  static const String messageIcon = 'assets/icons/message.svg';
  static const String arrowRightIcon = 'assets/icons/arrow_right.svg';
  static const String arrowUpRightIcon = 'assets/icons/arrow_up_right.svg';
  static const String downloadIcon = 'assets/icons/download.svg';

  static const String profilePhoto = 'assets/images/profile.jpg';
  static const String brandMark = 'assets/branding/mark.png';
  static const String resumePdf = 'assets/docs/curriculo_luan_nunes.pdf';

  static String projectIcon(String id) =>
      'assets/images/projects/${id}_icon.png';

  static String projectScreen(String id) =>
      'assets/images/projects/${id}_screen.png';
}
