import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class SitePillButton extends StatelessWidget {
  const SitePillButton({
    required this.label,
    required this.foreground,
    required this.onPressed,
    this.background,
    this.borderColor,
    this.leadingIcon,
    this.trailingIcon,
    this.height = SiteMetrics.heroButton,
    this.textStyle = SiteTypography.button,
    super.key,
  });

  final String label;
  final Color foreground;
  final VoidCallback onPressed;
  final Color? background;
  final Color? borderColor;
  final AppIconType? leadingIcon;
  final AppIconType? trailingIcon;
  final double height;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final shape = StadiumBorder(
      side: borderColor == null
          ? BorderSide.none
          : BorderSide(color: borderColor!, width: AppSizes.outlineBorder),
    );

    return Semantics(
      button: true,
      child: Material(
        color: background ?? Colors.transparent,
        shape: shape,
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 2),
            child: SizedBox(
              height: height,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    AppIcon(type: leadingIcon!, color: foreground),
                    const SizedBox(width: AppSpacing.m),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle.copyWith(color: foreground),
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: AppSpacing.m),
                    AppIcon(type: trailingIcon!, color: foreground),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
