import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/home/models/highlight_stat_model.dart';

class HighlightStatItem extends StatelessWidget {
  const HighlightStatItem({
    required this.stat,
    required this.palette,
    super.key,
  });

  final HighlightStatModel stat;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    final titleStyle = stat.emphasis
        ? AppTypography.headline
        : AppTypography.bodyStrong;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(stat.title, style: titleStyle.copyWith(color: palette.text)),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          stat.subtitle,
          style: AppTypography.body.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}
