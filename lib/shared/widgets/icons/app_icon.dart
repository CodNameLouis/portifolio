import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    required this.type,
    required this.color,
    this.size = AppSizes.iconButton,
    super.key,
  });

  final AppIconType type;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      type.path,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
