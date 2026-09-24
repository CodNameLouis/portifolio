import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_luan/app/router/app_routes.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/home/controllers/home_bloc.dart';
import 'package:portfolio_luan/features/home/controllers/home_event.dart';
import 'package:portfolio_luan/features/home/controllers/home_state.dart';
import 'package:portfolio_luan/features/home/models/profile_model.dart';
import 'package:portfolio_luan/features/home/views/widgets/highlight_stats_list.dart';
import 'package:portfolio_luan/features/home/views/widgets/home_actions.dart';
import 'package:portfolio_luan/features/home/views/widgets/home_greeting.dart';
import 'package:portfolio_luan/features/home/views/widgets/home_name_title.dart';
import 'package:portfolio_luan/features/home/views/widgets/profile_photo_card.dart';
import 'package:portfolio_luan/shared/widgets/chips/status_pill.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';
import 'package:portfolio_luan/shared/widgets/feedback/loading_view.dart';
import 'package:portfolio_luan/shared/widgets/layout/fade_slide_in.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = ScreenPalette.forIndex(AppRoutes.homeIndex);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeInitial() || HomeLoading() => LoadingView(palette: palette),
          HomeFailure(:final failure) => ErrorView(
            message: failure.message,
            palette: palette,
            onRetry: () => context.read<HomeBloc>().add(const HomeStarted()),
          ),
          HomeLoaded(:final profile) => _HomeContent(
            profile: profile,
            palette: palette,
          ),
        };
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.profile, required this.palette});

  final ProfileModel profile;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 0,
            child: PageHeader(
              palette: palette,
              trailing: profile.available
                  ? StatusPill(label: profile.availabilityLabel)
                  : null,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.x3l,
                AppSpacing.pageHorizontal,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeGreeting(greeting: profile.greeting, palette: palette),
                  const SizedBox(height: AppSpacing.xl),
                  HomeNameTitle(
                    firstName: profile.firstName,
                    lastName: profile.lastName,
                    role: profile.role,
                    palette: palette,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.bioMaxWidth,
                    ),
                    child: Text(
                      profile.bio,
                      style: AppTypography.bodyLarge.copyWith(
                        color: palette.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.x6l,
                AppSpacing.pageHorizontal,
                0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ProfilePhotoCard(photo: profile.photo),
                  const SizedBox(width: AppSpacing.x3l),
                  Expanded(
                    child: HighlightStatsList(
                      stats: profile.stats,
                      palette: palette,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.x6l,
                AppSpacing.pageHorizontal,
                AppSpacing.x6l,
              ),
              child: HomeActions(
                palette: palette,
                onProjectsPressed: () =>
                    _goToBranch(context, AppRoutes.projectsIndex),
                onContactPressed: () =>
                    _goToBranch(context, AppRoutes.contactIndex),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _goToBranch(BuildContext context, int index) {
    StatefulNavigationShell.of(context).goBranch(index);
  }
}
