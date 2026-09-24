import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/shared/widgets/buttons/primary_pill_button.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class ResumeButton extends StatelessWidget {
  const ResumeButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.xxl,
        AppSpacing.pageHorizontal,
        0,
      ),
      child: PrimaryPillButton(
        label: AppStrings.contactResumeButton,
        background: AppColors.sand,
        foreground: AppColors.navy,
        leadingIcon: AppIconType.download,
        onPressed: onPressed,
      ),
    );
  }
}
