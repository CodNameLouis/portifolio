import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';

class FilterPill extends StatelessWidget {
  const FilterPill({
    required this.label,
    required this.selected,
    required this.selectedBackground,
    required this.selectedForeground,
    required this.foreground,
    required this.borderColor,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool selected;
  final Color selectedBackground;
  final Color selectedForeground;
  final Color foreground;
  final Color borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final shape = StadiumBorder(
      side: selected
          ? BorderSide.none
          : BorderSide(color: borderColor, width: AppSizes.hairline),
    );

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: (AppSizes.minTouchTarget - AppSizes.filterPill) / 2,
            ),
            child: Container(
              height: AppSizes.filterPill,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              decoration: ShapeDecoration(
                color: selected ? selectedBackground : Colors.transparent,
                shape: shape,
              ),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  style: selected
                      ? AppTypography.captionStrong.copyWith(
                          color: selectedForeground,
                        )
                      : AppTypography.captionMedium.copyWith(color: foreground),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
