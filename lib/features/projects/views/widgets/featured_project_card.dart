import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_radius.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';
import 'package:portfolio_luan/features/projects/views/widgets/phone_mockup.dart';
import 'package:portfolio_luan/shared/widgets/chips/badge_pill.dart';

class FeaturedProjectCard extends StatelessWidget {
  const FeaturedProjectCard({
    required this.project,
    required this.onPressed,
    super.key,
  });

  final ProjectModel project;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.cardHorizontal,
        AppSpacing.xxl,
        AppSpacing.cardHorizontal,
        0,
      ),
      child: Material(
        color: AppColors.terracotta,
        borderRadius: AppRadius.featuredAll,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.featuredCard),
            child: Stack(
              children: [
                Positioned(
                  top: AppSizes.phoneTop,
                  right: -AppSizes.phoneRight,
                  child: Transform.rotate(
                    angle: AppSizes.phoneRotationDegrees * math.pi / 180,
                    child: PhoneMockup(screenshot: project.screenshot),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.x4l),
                  child: SizedBox(
                    width: AppSizes.featuredTextWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BadgePill(
                          label: AppStrings.projectsFeaturedBadge,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          project.name,
                          style: AppTypography.headline.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          project.summary,
                          style: AppTypography.body.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          project.roles.join(AppStrings.separator),
                          style: AppTypography.captionStrong.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
