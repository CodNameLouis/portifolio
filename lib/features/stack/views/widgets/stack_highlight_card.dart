import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_radius.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/features/stack/models/stack_highlight_model.dart';
import 'package:portfolio_luan/shared/widgets/chips/badge_pill.dart';

class StackHighlightCard extends StatelessWidget {
  const StackHighlightCard({required this.highlight, super.key});

  final StackHighlightModel highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.cardHorizontal,
        AppSpacing.xxl,
        AppSpacing.cardHorizontal,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3l,
          vertical: AppSpacing.xxl,
        ),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: AppRadius.stackHighlightAll,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    highlight.title,
                    style: AppTypography.headline.copyWith(
                      color: AppColors.sand,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    highlight.subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.beige,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            BadgePill(
              label: highlight.level,
              height: AppSizes.badgePillLarge,
              horizontalPadding: AppSpacing.md,
            ),
          ],
        ),
      ),
    );
  }
}
