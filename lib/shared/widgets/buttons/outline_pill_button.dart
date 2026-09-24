import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';

class OutlinePillButton extends StatelessWidget {
  const OutlinePillButton({
    required this.label,
    required this.foreground,
    required this.onPressed,
    this.width,
    super.key,
  });

  final String label;
  final Color foreground;
  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final shape = StadiumBorder(
      side: BorderSide(color: foreground, width: AppSizes.outlineBorder),
    );

    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        shape: shape,
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: SizedBox(
            width: width,
            height: AppSizes.pillButton,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.button.copyWith(color: foreground),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
