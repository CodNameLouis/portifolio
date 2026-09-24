import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_radius.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';

class ProjectThumbnail extends StatelessWidget {
  const ProjectThumbnail({
    required this.icon,
    required this.fallbackColor,
    super.key,
  });

  final String icon;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.thumbnailAll,
      child: Container(
        width: AppSizes.thumbnail,
        height: AppSizes.thumbnail,
        color: fallbackColor,
        child: Image.asset(
          icon,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
