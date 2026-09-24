import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    required this.label,
    required this.foreground,
    required this.borderColor,
    super.key,
  });

  final String label;
  final Color foreground;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.tagChip,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(color: borderColor, width: AppSizes.hairline),
        ),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: AppTypography.captionMedium.copyWith(color: foreground),
        ),
      ),
    );
  }
}
