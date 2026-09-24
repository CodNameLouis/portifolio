import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/features/home/models/profile_model.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_photo_card.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_pill_button.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class SiteHero extends StatelessWidget {
  const SiteHero({
    required this.profile,
    required this.onProjectsPressed,
    required this.onResumePressed,
    super.key,
  });

  final ProfileModel profile;
  final VoidCallback onProjectsPressed;
  final VoidCallback onResumePressed;

  @override
  Widget build(BuildContext context) {
    return SiteSection(
      padding: const EdgeInsets.only(top: SiteMetrics.heroTop),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = SiteMetrics.isCompact(constraints.maxWidth);
          final texto = _SiteHeroText(
            profile: profile,
            compact: compact,
            onProjectsPressed: onProjectsPressed,
            onResumePressed: onResumePressed,
          );
          final foto = SitePhotoCard(photo: profile.photo);

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                texto,
                const SizedBox(height: SiteMetrics.columnGap),
                Center(child: foto),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: texto),
              const SizedBox(width: SiteMetrics.columnGap),
              foto,
            ],
          );
        },
      ),
    );
  }
}

class _SiteHeroText extends StatelessWidget {
  const _SiteHeroText({
    required this.profile,
    required this.compact,
    required this.onProjectsPressed,
    required this.onResumePressed,
  });

  final ProfileModel profile;
  final bool compact;
  final VoidCallback onProjectsPressed;
  final VoidCallback onResumePressed;

  @override
  Widget build(BuildContext context) {
    final nome = compact
        ? SiteTypography.sectionTitle
        : SiteTypography.heroName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.greeting,
          style: SiteTypography.bodySmall.copyWith(color: AppColors.slate),
        ),
        const SizedBox(height: AppSpacing.x6l),
        Semantics(
          header: true,
          label: '${profile.firstName} ${profile.lastName}, ${profile.role}',
          child: ExcludeSemantics(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${profile.firstName} '),
                  TextSpan(
                    text: profile.lastName,
                    style: const TextStyle(color: AppColors.terracotta),
                  ),
                ],
              ),
              style: nome.copyWith(color: AppColors.navy),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x6l),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: SiteMetrics.heroBioWidth),
          child: Text(
            profile.bio,
            style: SiteTypography.lead.copyWith(color: AppColors.navy),
          ),
        ),
        const SizedBox(height: SiteMetrics.heroTop),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            SitePillButton(
              label: AppStrings.homeViewProjects,
              background: AppColors.terracotta,
              foreground: AppColors.white,
              trailingIcon: AppIconType.arrowRight,
              onPressed: onProjectsPressed,
            ),
            SitePillButton(
              label: AppStrings.siteResumeShort,
              foreground: AppColors.navy,
              borderColor: AppColors.navy,
              leadingIcon: AppIconType.download,
              onPressed: onResumePressed,
            ),
          ],
        ),
      ],
    );
  }
}
