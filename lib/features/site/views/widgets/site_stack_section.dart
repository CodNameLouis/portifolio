import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section_heading.dart';
import 'package:portfolio_luan/features/stack/models/skill_group_model.dart';
import 'package:portfolio_luan/features/stack/models/stack_highlight_model.dart';
import 'package:portfolio_luan/features/stack/models/stack_model.dart';

class SiteStackSection extends StatelessWidget {
  const SiteStackSection({required this.stack, super.key});

  final StackModel stack;

  @override
  Widget build(BuildContext context) {
    final highlight = stack.highlight;

    return SiteSection(
      padding: const EdgeInsets.only(top: SiteMetrics.sectionGap),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = SiteMetrics.isCompact(constraints.maxWidth);

          final esquerda = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SiteSectionHeading(
                title: AppStrings.stackTitle,
                subtitle: AppStrings.stackSubtitle,
              ),
              if (highlight != null) ...[
                const SizedBox(height: AppSpacing.x6l),
                _SiteStackHighlight(highlight: highlight),
              ],
            ],
          );

          final direita = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < stack.groups.length; index++)
                _SiteSkillGroup(
                  group: stack.groups[index],
                  first: index == 0,
                  compact: compact,
                ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                esquerda,
                const SizedBox(height: SiteMetrics.stackGap),
                direita,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: SiteMetrics.stackColumn, child: esquerda),
              const SizedBox(width: SiteMetrics.stackGap),
              Expanded(child: direita),
            ],
          );
        },
      ),
    );
  }
}

class _SiteStackHighlight extends StatelessWidget {
  const _SiteStackHighlight({required this.highlight});

  final StackHighlightModel highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SiteMetrics.stackCardPadding),
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: SiteMetrics.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: AppSizes.tagChip,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            alignment: Alignment.center,
            decoration: const ShapeDecoration(
              color: AppColors.mustard,
              shape: StadiumBorder(),
            ),
            child: Text(
              highlight.level,
              style: SiteTypography.badge.copyWith(color: AppColors.navy),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            highlight.title,
            style: SiteTypography.highlightTitle.copyWith(
              color: AppColors.sand,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            highlight.subtitle,
            style: SiteTypography.bodySmall.copyWith(color: AppColors.beige),
          ),
        ],
      ),
    );
  }
}

class _SiteSkillGroup extends StatelessWidget {
  const _SiteSkillGroup({
    required this.group,
    required this.first,
    required this.compact,
  });

  final SkillGroupModel group;
  final bool first;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final rotulo = Text(
      group.label,
      style: SiteTypography.groupLabel.copyWith(color: AppColors.navy),
    );

    final chips = Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: [
        for (final item in group.items)
          Container(
            height: SiteMetrics.chipHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            decoration: const ShapeDecoration(
              shape: StadiumBorder(
                side: BorderSide(
                  color: AppColors.navyAlpha28,
                  width: AppSizes.hairline,
                ),
              ),
            ),
            child: Center(
              widthFactor: 1,
              child: Text(
                item,
                style: SiteTypography.chip.copyWith(color: AppColors.navy),
              ),
            ),
          ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3l),
      decoration: first
          ? null
          : const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.navyAlpha18,
                  width: AppSizes.hairline,
                ),
              ),
            ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                rotulo,
                const SizedBox(height: AppSpacing.md),
                chips,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: SiteMetrics.stackGroupLabel,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.s),
                    child: rotulo,
                  ),
                ),
                const SizedBox(width: AppSpacing.x5l),
                Expanded(child: chips),
              ],
            ),
    );
  }
}
