import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';

class BadgePill extends StatelessWidget {
  const BadgePill({
    required this.label,
    this.background = AppColors.mustard,
    this.foreground = AppColors.navy,
    this.height = AppSizes.badgePill,
    this.horizontalPadding = AppSpacing.m,
    super.key,
  });

  final String label;
  final Color background;
  final Color foreground;
  final double height;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: ShapeDecoration(
        color: background,
        shape: const StadiumBorder(),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: AppTypography.badge.copyWith(color: foreground),
        ),
      ),
    );
  }
}
