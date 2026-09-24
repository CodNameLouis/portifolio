import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/home/models/highlight_stat_model.dart';
import 'package:portfolio_luan/features/home/views/widgets/highlight_stat_item.dart';
import 'package:portfolio_luan/shared/widgets/layout/divided_column.dart';

class HighlightStatsList extends StatelessWidget {
  const HighlightStatsList({
    required this.stats,
    required this.palette,
    super.key,
  });

  final List<HighlightStatModel> stats;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return DividedColumn(
      dividerColor: AppColors.navyAlpha20,
      spacingAbove: AppSpacing.lg,
      spacingBelow: AppSpacing.md,
      children: [
        for (final stat in stats)
          HighlightStatItem(stat: stat, palette: palette),
      ],
    );
  }
}
