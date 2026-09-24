import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/features/home/models/highlight_stat_model.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section.dart';

class SiteStats extends StatelessWidget {
  const SiteStats({required this.stats, super.key});

  final List<HighlightStatModel> stats;

  @override
  Widget build(BuildContext context) {
    return SiteSection(
      padding: const EdgeInsets.only(top: AppSpacing.x6l * 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = SiteMetrics.isCompact(constraints.maxWidth);
          final itens = [for (final stat in stats) _SiteStatItem(stat: stat)];

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in itens)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x5l),
                    child: item,
                  ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < itens.length; index++) ...[
                if (index > 0) const SizedBox(width: SiteMetrics.projectGap),
                Expanded(child: itens[index]),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SiteStatItem extends StatelessWidget {
  const _SiteStatItem({required this.stat});

  final HighlightStatModel stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: AppSpacing.x3l),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.navyAlpha20,
            width: AppSizes.hairline,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.title,
            style: SiteTypography.statTitle.copyWith(color: AppColors.navy),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            stat.subtitle,
            style: SiteTypography.label.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }
}
