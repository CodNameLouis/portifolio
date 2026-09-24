import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/app/router/app_routes.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_bloc.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_event.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_state.dart';
import 'package:portfolio_luan/features/stack/models/stack_model.dart';
import 'package:portfolio_luan/features/stack/views/widgets/skill_group_row.dart';
import 'package:portfolio_luan/features/stack/views/widgets/stack_highlight_card.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';
import 'package:portfolio_luan/shared/widgets/feedback/loading_view.dart';
import 'package:portfolio_luan/shared/widgets/layout/divided_column.dart';
import 'package:portfolio_luan/shared/widgets/layout/fade_slide_in.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_header.dart';
import 'package:portfolio_luan/shared/widgets/layout/page_title.dart';

class StackPage extends StatelessWidget {
  const StackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = ScreenPalette.forIndex(AppRoutes.stackIndex);

    return BlocBuilder<StackBloc, StackState>(
      builder: (context, state) {
        return switch (state) {
          StackInitial() || StackLoading() => LoadingView(palette: palette),
          StackFailure(:final failure) => ErrorView(
            message: failure.message,
            palette: palette,
            onRetry: () => context.read<StackBloc>().add(const StackStarted()),
          ),
          StackLoaded(:final stack) => _StackContent(
            stack: stack,
            palette: palette,
          ),
        };
      },
    );
  }
}

class _StackContent extends StatelessWidget {
  const _StackContent({required this.stack, required this.palette});

  final StackModel stack;
  final ScreenPalette palette;

  double _labelWidth(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    var widest = AppSizes.skillGroupLabel;

    for (final group in stack.groups) {
      final painter = TextPainter(
        text: TextSpan(text: group.label, style: AppTypography.captionStrong),
        textDirection: Directionality.of(context),
        textScaler: scaler,
      )..layout();

      widest = math.max(widest, painter.width);
    }

    return widest;
  }

  @override
  Widget build(BuildContext context) {
    final highlight = stack.highlight;
    final labelWidth = _labelWidth(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FadeSlideIn(order: 0, child: PageHeader(palette: palette)),
        ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 1,
            child: PageTitle(
              title: AppStrings.stackTitle,
              subtitle: AppStrings.stackSubtitle,
              palette: palette,
            ),
          ),
        ),
        if (highlight != null)
          SliverToBoxAdapter(
            child: FadeSlideIn(
              order: 2,
              child: StackHighlightCard(highlight: highlight),
            ),
          ),
        SliverToBoxAdapter(
          child: FadeSlideIn(
            order: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.sm,
                AppSpacing.pageHorizontal,
                AppSpacing.x6l,
              ),
              child: DividedColumn(
                dividerColor: AppColors.navyAlpha16,
                itemPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                ),
                children: [
                  for (final group in stack.groups)
                    SkillGroupRow(
                      group: group,
                      palette: palette,
                      labelWidth: labelWidth,
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
