import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';

class SitePhotoCard extends StatelessWidget {
  const SitePhotoCard({required this.photo, super.key});

  final String photo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SiteMetrics.heroPhotoWidth + SiteMetrics.heroCircleOffset,
      height: SiteMetrics.heroPhotoHeight + SiteMetrics.heroCircleOffset,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: SiteMetrics.heroCircle,
              height: SiteMetrics.heroCircle,
              decoration: const BoxDecoration(
                color: AppColors.mustard,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: SiteMetrics.heroPhotoRadius,
              child: Container(
                width: SiteMetrics.heroPhotoWidth,
                height: SiteMetrics.heroPhotoHeight,
                color: AppColors.navy,
                child: Image.asset(
                  photo,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
