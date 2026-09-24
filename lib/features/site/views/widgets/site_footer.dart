import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({
    required this.credits,
    required this.onBackToTop,
    super.key,
  });

  final String credits;
  final VoidCallback onBackToTop;

  @override
  Widget build(BuildContext context) {
    return SiteSection(
      background: AppColors.navy,
      child: SizedBox(
        height: SiteMetrics.footerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.brandMark,
                    width: AppSizes.logoBadge,
                    height: AppSizes.logoBadge,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Flexible(
                    child: Text(
                      credits,
                      maxLines: 2,
                      style: SiteTypography.footer.copyWith(
                        color: AppColors.beige,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xl),
            Semantics(
              button: true,
              child: InkWell(
                onTap: onBackToTop,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.s,
                  ),
                  child: Text(
                    AppStrings.siteBackToTop,
                    style: SiteTypography.labelMedium.copyWith(
                      color: AppColors.sand,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
