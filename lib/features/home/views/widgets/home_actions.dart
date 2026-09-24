import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/shared/widgets/buttons/outline_pill_button.dart';
import 'package:portfolio_luan/shared/widgets/buttons/primary_pill_button.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class HomeActions extends StatelessWidget {
  const HomeActions({
    required this.palette,
    required this.onProjectsPressed,
    required this.onContactPressed,
    super.key,
  });

  final ScreenPalette palette;
  final VoidCallback onProjectsPressed;
  final VoidCallback onContactPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryPillButton(
            label: AppStrings.homeViewProjects,
            background: AppColors.terracotta,
            foreground: AppColors.white,
            trailingIcon: AppIconType.arrowRight,
            onPressed: onProjectsPressed,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        OutlinePillButton(
          label: AppStrings.homeContact,
          foreground: palette.text,
          width: AppSizes.outlineButtonWidth,
          onPressed: onContactPressed,
        ),
      ],
    );
  }
}
