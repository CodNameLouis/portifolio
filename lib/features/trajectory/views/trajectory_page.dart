import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/app/router/app_routes.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_bloc.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_event.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_state.dart';
import 'package:portfolio_luan/features/trajectory/models/trajectory_model.dart';
import 'package:portfolio_luan/features/trajectory/views/widgets/education_card.dart';
import 'package:portfolio_luan/features/trajectory/views/widgets/timeline_list.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';
import 'package:portfolio_luan/shared/widgets/feedback/loading_view.dart';
import 'package:portfolio_luan/shared/widgets/layout/fade_slide_in.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_header.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_title.dart';

class TrajectoryPage extends StatelessWidget {
  const TrajectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = ScreenPalette.forIndex(AppRoutes.trajectoryIndex);

    return BlocBuilder<TrajectoryBloc, TrajectoryState>(
      builder: (context, state) {
        return switch (state) {
          TrajectoryInitial() ||
          TrajectoryLoading() => LoadingView(palette: palette),
          TrajectoryFailure(:final failure) => ErrorView(
            message: failure.message,
            palette: palette,
            onRetry: () =>
                context.read<TrajectoryBloc>().add(const TrajectoryStarted()),
          ),
          TrajectoryLoaded(:final trajectory) => _TrajectoryContent(
            trajectory: trajectory,
            palette: palette,
          ),
        };
      },
    );
  }
}

class _TrajectoryContent extends StatelessWidget {
  const _TrajectoryContent({required this.trajectory, required this.palette});

  final TrajectoryModel trajectory;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FadeSlideIn(order: 0, child: PageHeader(palette: palette)),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 1,
            child: PageTitle(
              title: AppStrings.trajectoryTitle,
              subtitle: AppStrings.trajectorySubtitle,
              palette: palette,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 2,
            child: TimelineList(
              experiences: trajectory.experiences,
              palette: palette,
            ),
          ),
        ),
        if (trajectory.education.isNotEmpty)
          SliverToBoxAdapter(
            child: FadeSlideIn(
              order: 3,
              child: EducationCard(education: trajectory.education),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.x6l)),
      ],
    );
  }
}
