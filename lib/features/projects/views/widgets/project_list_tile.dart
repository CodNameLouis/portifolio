import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';
import 'package:portfolio_luan/features/projects/views/widgets/project_thumbnail.dart';
import 'package:portfolio_luan/shared/widgets/buttons/circle_arrow_button.dart';

class ProjectListTile extends StatelessWidget {
  const ProjectListTile({
    required this.project,
    required this.palette,
    required this.onPressed,
    super.key,
  });

  final ProjectModel project;
  final ScreenPalette palette;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: project.name,
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            ProjectThumbnail(
              icon: project.icon,
              fallbackColor: project.thumbColor,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: AppTypography.itemTitle.copyWith(
                      color: palette.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    project.tags.join(AppStrings.separator),
                    style: AppTypography.caption.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            CircleArrowButton(
              color: palette.text,
              borderColor: AppColors.navyAlpha25,
            ),
          ],
        ),
      ),
    );
  }
}
