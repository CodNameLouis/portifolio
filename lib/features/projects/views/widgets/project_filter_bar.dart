import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/projects/models/project_category.dart';
import 'package:portfolio_luan/shared/widgets/chips/filter_pill.dart';

class ProjectFilterBar extends StatelessWidget {
  const ProjectFilterBar({
    required this.selected,
    required this.palette,
    required this.onCategorySelected,
    super.key,
  });

  final ProjectCategory selected;
  final ScreenPalette palette;
  final ValueChanged<ProjectCategory> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.xxl,
        AppSpacing.pageHorizontal,
        0,
      ),
      child: Row(
        children: [
          for (final category in ProjectCategory.values) ...[
            if (category != ProjectCategory.values.first)
              const SizedBox(width: AppSpacing.s),
            FilterPill(
              label: category.label,
              selected: category == selected,
              selectedBackground: AppColors.navy,
              selectedForeground: AppColors.sand,
              foreground: palette.text,
              borderColor: AppColors.navyAlpha28,
              onPressed: () => onCategorySelected(category),
            ),
          ],
        ],
      ),
    );
  }
}
