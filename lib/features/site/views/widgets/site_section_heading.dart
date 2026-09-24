import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';

class SiteSectionHeading extends StatelessWidget {
  const SiteSectionHeading({
    required this.title,
    required this.subtitle,
    this.trailing,
    this.titleColor = AppColors.navy,
    this.subtitleColor = AppColors.slate,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: SiteTypography.sectionTitle.copyWith(color: titleColor),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          subtitle,
          style: SiteTypography.body.copyWith(color: subtitleColor),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (trailing == null) {
          return texto;
        }

        if (SiteMetrics.isCompact(constraints.maxWidth)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              texto,
              const SizedBox(height: AppSpacing.x5l),
              trailing!,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: texto),
            const SizedBox(width: SiteMetrics.projectGap),
            trailing!,
          ],
        );
      },
    );
  }
}
