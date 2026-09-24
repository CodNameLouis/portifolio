import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class SiteProjectTile extends StatelessWidget {
  const SiteProjectTile({
    required this.project,
    required this.onPressed,
    super.key,
  });

  final ProjectModel project;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: project.name,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x5l),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.navyAlpha20,
                width: AppSizes.hairline,
              ),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: SiteMetrics.thumbRadius,
                child: Container(
                  width: SiteMetrics.projectThumb,
                  height: SiteMetrics.projectThumb,
                  color: project.thumbColor,
                  child: Image.asset(
                    project.icon,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: SiteTypography.projectName.copyWith(
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      project.tags.join(AppStrings.separator),
                      style: SiteTypography.label.copyWith(
                        color: AppColors.slate,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3l),
              Container(
                width: SiteMetrics.projectArrow,
                height: SiteMetrics.projectArrow,
                alignment: Alignment.center,
                decoration: const ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide(
                      color: AppColors.navyAlpha25,
                      width: AppSizes.hairline,
                    ),
                  ),
                ),
                child: const AppIcon(
                  type: AppIconType.arrowUpRight,
                  color: AppColors.navy,
                  size: AppSizes.iconLink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
