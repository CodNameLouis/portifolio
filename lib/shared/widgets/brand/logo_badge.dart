import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';

class LogoBadge extends StatelessWidget {
  const LogoBadge({required this.palette, this.onTap, super.key});

  final ScreenPalette palette;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: AppStrings.navHome,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: AppSizes.logoBadge,
          height: AppSizes.logoBadge,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.logoBackground,
            shape: BoxShape.circle,
          ),
          child: Text(
            AppStrings.logo,
            style: AppTypography.logo.copyWith(color: palette.logoText),
          ),
        ),
      ),
    );
  }
}
