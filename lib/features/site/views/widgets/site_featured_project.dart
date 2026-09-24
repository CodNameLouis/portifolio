import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_phone_mockup.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_pill_button.dart';
import 'package:portfolio_luan/shared/widgets/chips/badge_pill.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class SiteFeaturedProject extends StatelessWidget {
  const SiteFeaturedProject({
    required this.project,
    required this.onPressed,
    super.key,
  });

  final ProjectModel project;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = SiteMetrics.isCompact(constraints.maxWidth);
        final mostraCelular =
            constraints.maxWidth >= SiteMetrics.featuredPhoneMin;
        final texto = _SiteFeaturedText(
          project: project,
          compact: compact,
          onPressed: onPressed,
        );

        return DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.terracotta,
            borderRadius: SiteMetrics.featuredRadius,
          ),
          child: ClipRRect(
            borderRadius: SiteMetrics.featuredRadius,
            child: compact
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.x6l),
                    child: texto,
                  )
                : SizedBox(
                    height: SiteMetrics.featuredCard,
                    child: Stack(
                      children: [
                        if (mostraCelular)
                          Positioned(
                            right: SiteMetrics.phoneRight,
                            top: SiteMetrics.phoneTop,
                            child: SitePhoneMockup(
                              screenshot: project.screenshot,
                              angleDegrees: SiteMetrics.phoneAngle,
                            ),
                          ),
                        Positioned(
                          left: SiteMetrics.featuredPadding,
                          top: SiteMetrics.featuredPadding,
                          width: SiteMetrics.featuredTextWidth,
                          child: texto,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _SiteFeaturedText extends StatelessWidget {
  const _SiteFeaturedText({
    required this.project,
    required this.compact,
    required this.onPressed,
  });

  final ProjectModel project;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BadgePill(
          label: AppStrings.projectsFeaturedBadge,
          height: AppSizes.badgePillLarge + AppSpacing.xxs,
          horizontalPadding: AppSpacing.md,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          project.name,
          style:
              (compact
                      ? SiteTypography.sectionTitle
                      : SiteTypography.featuredName)
                  .copyWith(color: AppColors.white),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          project.summary,
          style: SiteTypography.body.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          project.roles.join(AppStrings.separator),
          style: SiteTypography.labelStrong.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: AppSpacing.x5l),
        SitePillButton(
          label: AppStrings.siteFeaturedCta,
          background: AppColors.white,
          foreground: AppColors.terracotta,
          height: SiteMetrics.featuredButton,
          trailingIcon: AppIconType.arrowRight,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
