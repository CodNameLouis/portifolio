import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_radius.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';

class ProfilePhotoCard extends StatelessWidget {
  const ProfilePhotoCard({required this.photo, super.key});

  final String photo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.profilePhotoWidth + AppSizes.profileCircleOffset,
      height: AppSizes.profilePhotoHeight + AppSizes.profileCircleOffset,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: AppSizes.profileCircle,
              height: AppSizes.profileCircle,
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
              borderRadius: AppRadius.photo,
              child: Container(
                width: AppSizes.profilePhotoWidth,
                height: AppSizes.profilePhotoHeight,
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
