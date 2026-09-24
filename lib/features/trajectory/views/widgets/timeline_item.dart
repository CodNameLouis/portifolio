import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/trajectory/models/experience_model.dart';
import 'package:portfolio_luan/features/trajectory/views/widgets/timeline_dot.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    required this.experience,
    required this.isLast,
    required this.palette,
    super.key,
  });

  final ExperienceModel experience;
  final bool isLast;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: AppSizes.timelineColumn,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: TimelineDot(current: experience.current),
                ),
                if (!isLast)
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.s),
                      child: SizedBox(
                        width: AppSizes.timelineLine,
                        child: ColoredBox(color: AppColors.mustardAlpha35),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x4l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.period,
                    style: AppTypography.captionStrong.copyWith(
                      color: AppColors.mustard,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    experience.role,
                    style: AppTypography.title.copyWith(color: palette.text),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    [experience.company, experience.mode]
                        .where((part) => part.isNotEmpty)
                        .join(AppStrings.separator),
                    style: AppTypography.caption.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    experience.description,
                    style: AppTypography.bodyTall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
