import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/app/router/app_routes.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_bloc.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_event.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_state.dart';
import 'package:portfolio_luan/features/projects/views/widgets/featured_project_card.dart';
import 'package:portfolio_luan/features/projects/views/widgets/project_filter_bar.dart';
import 'package:portfolio_luan/features/projects/views/widgets/project_list_tile.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';
import 'package:portfolio_luan/shared/widgets/feedback/loading_view.dart';
import 'package:portfolio_luan/shared/widgets/layout/divided_column.dart';
import 'package:portfolio_luan/shared/widgets/layout/fade_slide_in.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_header.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_title.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = ScreenPalette.forIndex(AppRoutes.projectsIndex);

    return BlocConsumer<ProjectsBloc, ProjectsState>(
      listenWhen: (previous, current) =>
          current is ProjectsLoaded && current.launchFailure != null,
      listener: (context, state) {
        final failure = (state as ProjectsLoaded).launchFailure!;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            duration: AppDurations.snackBar,
          ),
        );
      },
      builder: (context, state) {
        return switch (state) {
          ProjectsInitial() ||
          ProjectsLoading() => LoadingView(palette: palette),
          ProjectsFailure(:final failure) => ErrorView(
            message: failure.message,
            palette: palette,
            onRetry: () =>
                context.read<ProjectsBloc>().add(const ProjectsStarted()),
          ),
          ProjectsLoaded() => _ProjectsContent(state: state, palette: palette),
        };
      },
    );
  }
}

class _ProjectsContent extends StatelessWidget {
  const _ProjectsContent({required this.state, required this.palette});

  final ProjectsLoaded state;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProjectsBloc>();
    final featured = state.featured;
    final others = state.others;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FadeSlideIn(order: 0, child: PageHeader(palette: palette)),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 1,
            child: PageTitle(
              title: AppStrings.projectsTitle,
              subtitle: AppStrings.projectsSubtitle,
              palette: palette,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 2,
            child: ProjectFilterBar(
              selected: state.selectedCategory,
              palette: palette,
              onCategorySelected: (category) =>
                  bloc.add(ProjectsFilterChanged(category)),
            ),
          ),
        ),
        if (featured != null)
          SliverToBoxAdapter(
            child: FadeSlideIn(
              order: 3,
              child: FeaturedProjectCard(
                project: featured,
                onPressed: () => bloc.add(ProjectOpened(featured)),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.s,
                AppSpacing.pageHorizontal,
                AppSpacing.x6l,
              ),
              child: DividedColumn(
                dividerColor: palette.divider,
                itemPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg,
                ),
                children: [
                  for (final project in others)
                    ProjectListTile(
                      project: project,
                      palette: palette,
                      onPressed: () => bloc.add(ProjectOpened(project)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
