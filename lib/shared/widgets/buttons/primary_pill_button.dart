import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class PrimaryPillButton extends StatelessWidget {
  const PrimaryPillButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    super.key,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;
  final AppIconType? leadingIcon;
  final AppIconType? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Material(
        color: background,
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: SizedBox(
            height: AppSizes.pillButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  AppIcon(type: leadingIcon!, color: foreground),
                  const SizedBox(width: AppSpacing.s),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.button.copyWith(color: foreground),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: AppSpacing.s),
                  AppIcon(type: trailingIcon!, color: foreground),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
