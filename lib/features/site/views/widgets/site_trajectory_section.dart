import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section_heading.dart';
import 'package:portfolio_luan/features/trajectory/models/education_model.dart';
import 'package:portfolio_luan/features/trajectory/models/experience_model.dart';
import 'package:portfolio_luan/features/trajectory/models/trajectory_model.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class SiteTrajectorySection extends StatelessWidget {
  const SiteTrajectorySection({required this.trajectory, super.key});

  final TrajectoryModel trajectory;

  @override
  Widget build(BuildContext context) {
    return SiteSection(
      background: AppColors.navy,
      padding: const EdgeInsets.symmetric(vertical: SiteMetrics.sectionPadding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = SiteMetrics.isCompact(constraints.maxWidth);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SiteSectionHeading(
                title: AppStrings.trajectoryTitle,
                subtitle: AppStrings.trajectorySubtitle,
                titleColor: AppColors.sand,
                subtitleColor: AppColors.beige,
              ),
              const SizedBox(height: SiteMetrics.stackGap),
              if (compact)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final experience in trajectory.experiences)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: SiteMetrics.timelineGap,
                        ),
                        child: _SiteTimelineItem(experience: experience),
                      ),
                  ],
                )
              else
                Stack(
                  children: [
                    const Positioned(
                      left: 0,
                      right: 0,
                      top:
                          SiteMetrics.timelineLineTop +
                          AppSizes.timelineLine / 2 -
                          SiteMetrics.timelineArrow / 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: AppSizes.timelineLine,
                              child: ColoredBox(
                                color: AppColors.mustardAlpha35,
                              ),
                            ),
                          ),
                          AppIcon(
                            type: AppIconType.arrowRight,
                            color: AppColors.mustardAlpha35,
                            size: SiteMetrics.timelineArrow,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (
                          var index = 0;
                          index < trajectory.experiences.length;
                          index++
                        ) ...[
                          if (index > 0)
                            const SizedBox(width: SiteMetrics.timelineGap),
                          Expanded(
                            child: _SiteTimelineItem(
                              experience: trajectory.experiences[index],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              if (trajectory.education.isNotEmpty) ...[
                const SizedBox(height: SiteMetrics.educationTop),
                _SiteEducationCard(
                  education: trajectory.education,
                  compact: compact,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SiteTimelineItem extends StatelessWidget {
  const _SiteTimelineItem({required this.experience});

  final ExperienceModel experience;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSpacing.x5l,
          child: Align(
            alignment: Alignment.centerLeft,
            child: experience.current
                ? Container(
                    width: SiteMetrics.timelineDotCurrent,
                    height: SiteMetrics.timelineDotCurrent,
                    decoration: const BoxDecoration(
                      color: AppColors.terracotta,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.terracottaAlpha30,
                          spreadRadius: SiteMetrics.timelineDotHalo,
                        ),
                      ],
                    ),
                  )
                : Container(
                    width: SiteMetrics.timelineDot,
                    height: SiteMetrics.timelineDot,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.mustard,
                        width: AppSizes.timelineDotBorder,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          experience.period,
          style: SiteTypography.labelStrong.copyWith(color: AppColors.mustard),
        ),
        const SizedBox(height: AppSpacing.m),
        Text(
          experience.role,
          style: SiteTypography.cardTitle.copyWith(color: AppColors.sand),
        ),
        const SizedBox(height: AppSpacing.m),
        Text(
          [
            experience.company,
            experience.mode,
          ].where((parte) => parte.isNotEmpty).join(AppStrings.separator),
          style: SiteTypography.label.copyWith(color: AppColors.beige),
        ),
        const SizedBox(height: AppSpacing.md),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: SiteMetrics.timelineTextWidth,
          ),
          child: Text(
            experience.description,
            style: SiteTypography.bodySmall.copyWith(color: AppColors.beige),
          ),
        ),
      ],
    );
  }
}

class _SiteEducationCard extends StatelessWidget {
  const _SiteEducationCard({required this.education, required this.compact});

  final List<EducationModel> education;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final titulo = Text(
      AppStrings.trajectoryEducationTitle,
      style: SiteTypography.labelStrong.copyWith(color: AppColors.mustard),
    );

    final itens = [
      for (final item in education)
        Text(
          [
            item.course,
            item.detail,
          ].where((parte) => parte.isNotEmpty).join(AppStrings.separator),
          style: SiteTypography.bodySmall.copyWith(color: AppColors.sand),
        ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x6l + AppSpacing.s,
        vertical: AppSpacing.x6l,
      ),
      decoration: const BoxDecoration(
        color: AppColors.navyDeep,
        borderRadius: SiteMetrics.educationRadius,
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titulo,
                for (final item in itens) ...[
                  const SizedBox(height: AppSpacing.md),
                  item,
                ],
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                titulo,
                for (final item in itens) ...[
                  const SizedBox(width: SiteMetrics.projectGap),
                  Flexible(child: item),
                ],
              ],
            ),
    );
  }
}
