import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_radius.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/features/trajectory/models/education_model.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({required this.education, super.key});

  final List<EducationModel> education;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.cardHorizontal,
        AppSpacing.x4l,
        AppSpacing.cardHorizontal,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3l,
          vertical: AppSpacing.xl,
        ),
        decoration: const BoxDecoration(
          color: AppColors.navyDeep,
          borderRadius: AppRadius.educationAll,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.trajectoryEducationTitle,
              style: AppTypography.captionStrong.copyWith(
                color: AppColors.mustard,
              ),
            ),
            for (final item in education) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                [
                  item.course,
                  item.detail,
                ].where((part) => part.isNotEmpty).join(AppStrings.separator),
                style: AppTypography.body.copyWith(color: AppColors.sand),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
