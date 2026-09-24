import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
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
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.pageTitle.copyWith(color: palette.text),
          ),
          const SizedBox(height: AppSpacing.sm),
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
