import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/stack/models/skill_group_model.dart';
import 'package:portfolio_luan/shared/widgets/chips/tag_chip.dart';

class SkillGroupRow extends StatelessWidget {
  const SkillGroupRow({
    required this.group,
    required this.palette,
    this.labelWidth = AppSizes.skillGroupLabel,
    super.key,
  });

  final SkillGroupModel group;
  final ScreenPalette palette;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              group.label,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: AppTypography.captionStrong.copyWith(color: palette.text),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final item in group.items)
                TagChip(
                  label: item,
                  foreground: palette.text,
                  borderColor: AppColors.navyAlpha28,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
