import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';

class ContactHero extends StatelessWidget {
  const ContactHero({
    required this.title,
    required this.subtitle,
    required this.palette,
    super.key,
  });

  final String title;
  final String subtitle;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.x3l,
        AppSpacing.pageHorizontal,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.contactTitle.copyWith(color: palette.text),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            subtitle,
            style: AppTypography.subtitle.copyWith(
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
