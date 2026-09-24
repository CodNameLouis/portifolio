import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_nav_link.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_pill_button.dart';
import 'package:portfolio_luan/features/site/views/widgets/site_section.dart';
import 'package:portfolio_luan/shared/widgets/chips/status_pill.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({
    required this.sections,
    required this.onSectionSelected,
    required this.onLogoPressed,
    required this.onContactPressed,
    this.availabilityLabel,
    super.key,
  });

  final List<String> sections;
  final ValueChanged<int> onSectionSelected;
  final VoidCallback onLogoPressed;
  final VoidCallback onContactPressed;
  final String? availabilityLabel;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.sand,
      child: SiteSection(
        child: SizedBox(
          height: SiteMetrics.headerHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = SiteMetrics.isCompact(constraints.maxWidth);
              final mostraStatus = SiteMetrics.showsStatus(
                constraints.maxWidth,
              );

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Semantics(
                      button: true,
                      child: InkWell(
                        onTap: onLogoPressed,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppAssets.brandMark,
                              width: SiteMetrics.headerLogo,
                              height: SiteMetrics.headerLogo,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Flexible(
                              child: Text(
                                AppStrings.appTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: SiteTypography.brand.copyWith(
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!compact)
                    Flexible(
                      child: Semantics(
                        container: true,
                        label: AppStrings.siteSections,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (
                                var index = 0;
                                index < sections.length;
                                index++
                              )
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0
                                        ? 0
                                        : SiteMetrics.headerGap,
                                  ),
                                  child: SiteNavLink(
                                    label: sections[index],
                                    onPressed: () => onSectionSelected(index),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (mostraStatus && availabilityLabel != null) ...[
                        StatusPill(label: availabilityLabel!),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      SitePillButton(
                        label: AppStrings.siteContactCta,
                        background: AppColors.navy,
                        foreground: AppColors.sand,
                        height: SiteMetrics.headerPill,
                        textStyle: SiteTypography.headerButton,
                        onPressed: onContactPressed,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
