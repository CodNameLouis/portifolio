import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_model.dart';
import 'package:portfolio_luan/features/contact/models/contact_model.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_pill_button.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class SiteContactSection extends StatelessWidget {
  const SiteContactSection({
    required this.contact,
    required this.onLinkPressed,
    required this.onResumePressed,
    super.key,
  });

  final ContactModel contact;
  final ValueChanged<String> onLinkPressed;
  final VoidCallback onResumePressed;

  @override
  Widget build(BuildContext context) {
    return SiteSection(
      background: AppColors.terracotta,
      padding: const EdgeInsets.symmetric(vertical: SiteMetrics.contactPadding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = SiteMetrics.isCompact(constraints.maxWidth);

          final chamada = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  contact.title,
                  style:
                      (compact
                              ? SiteTypography.sectionTitle
                              : SiteTypography.contactTitle)
                          .copyWith(color: AppColors.white),
                ),
              ),
              const SizedBox(height: AppSpacing.x5l),
              Text(
                contact.subtitle,
                style: SiteTypography.body.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: AppSpacing.x5l),
              SitePillButton(
                label: AppStrings.contactResumeButton,
                background: AppColors.sand,
                foreground: AppColors.navy,
                leadingIcon: AppIconType.download,
                onPressed: onResumePressed,
              ),
            ],
          );

          final links = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < contact.links.length; index++)
                _SiteContactLink(
                  link: contact.links[index],
                  first: index == 0,
                  onPressed: () => onLinkPressed(contact.links[index].url),
                ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                chamada,
                const SizedBox(height: SiteMetrics.stackGap),
                links,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: SiteMetrics.contactColumn, child: chamada),
              const SizedBox(width: SiteMetrics.stackGap),
              Expanded(child: links),
            ],
          );
        },
      ),
    );
  }
}

class _SiteContactLink extends StatelessWidget {
  const _SiteContactLink({
    required this.link,
    required this.first,
    required this.onPressed,
  });

  final ContactLinkModel link;
  final bool first;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: '${link.label}: ${link.value}',
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x5l),
          decoration: first
              ? null
              : const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.whiteAlpha32,
                      width: AppSizes.hairline,
                    ),
                  ),
                ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link.label,
                      style: SiteTypography.labelMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      link.value,
                      style: SiteTypography.cardTitle.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              const AppIcon(
                type: AppIconType.arrowUpRight,
                color: AppColors.white,
                size: AppSizes.iconLink,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
