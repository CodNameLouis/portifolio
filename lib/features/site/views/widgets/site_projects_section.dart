import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_state.dart';
import 'package:portfolio_luan/features/projects/models/project_category.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_featured_project.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_project_tile.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section_heading.dart';
import 'package:portfolio_luan/shared/widgets/chips/filter_pill.dart';

class SiteProjectsSection extends StatelessWidget {
  const SiteProjectsSection({
    required this.state,
    required this.onCategorySelected,
    required this.onProjectPressed,
    super.key,
  });

  final ProjectsLoaded state;
  final ValueChanged<ProjectCategory> onCategorySelected;
  final ValueChanged<ProjectModel> onProjectPressed;

  @override
  Widget build(BuildContext context) {
    final featured = state.featured;
    final others = state.others;

    return SiteSection(
      padding: const EdgeInsets.only(top: SiteMetrics.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SiteSectionHeading(
            title: AppStrings.projectsTitle,
            subtitle: AppStrings.projectsSubtitle,
            trailing: Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final category in ProjectCategory.values)
                  FilterPill(
                    label: category.label,
                    selected: category == state.selectedCategory,
                    selectedBackground: AppColors.navy,
                    selectedForeground: AppColors.sand,
                    foreground: AppColors.navy,
                    borderColor: AppColors.navyAlpha28,
                    onPressed: () => onCategorySelected(category),
                  ),
              ],
            ),
          ),
          const SizedBox(height: SiteMetrics.projectGap),
          if (featured != null) ...[
            SiteFeaturedProject(
              project: featured,
              onPressed: () => onProjectPressed(featured),
            ),
            const SizedBox(height: SiteMetrics.projectGap),
          ],
          _SiteProjectGrid(
            projects: others,
            onProjectPressed: onProjectPressed,
          ),
        ],
      ),
    );
  }
}

class _SiteProjectGrid extends StatelessWidget {
  const _SiteProjectGrid({
    required this.projects,
    required this.onProjectPressed,
  });

  final List<ProjectModel> projects;
  final ValueChanged<ProjectModel> onProjectPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colunas = SiteMetrics.isCompact(constraints.maxWidth) ? 1 : 2;
        final largura =
            (constraints.maxWidth - SiteMetrics.projectGap * (colunas - 1)) /
            colunas;

        return Wrap(
          spacing: SiteMetrics.projectGap,
          children: [
            for (final project in projects)
              SizedBox(
                width: largura,
                child: SiteProjectTile(
                  project: project,
                  onPressed: () => onProjectPressed(project),
                ),
              ),
          ],
        );
      },
    );
  }
}
