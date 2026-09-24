import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    this.background = AppColors.sandLight,
    this.foreground = AppColors.navy,
    this.borderColor = AppColors.navyAlpha18,
    this.dotColor = AppColors.terracotta,
    super.key,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Color borderColor;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.statusPill,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: ShapeDecoration(
        color: background,
        shape: StadiumBorder(
          side: BorderSide(color: borderColor, width: AppSizes.hairline),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.statusDot,
            height: AppSizes.statusDot,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.s),
          Text(
            label,
            style: AppTypography.captionMedium.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
