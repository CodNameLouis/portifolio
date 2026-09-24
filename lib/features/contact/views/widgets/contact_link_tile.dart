import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_model.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class ContactLinkTile extends StatelessWidget {
  const ContactLinkTile({
    required this.link,
    required this.palette,
    required this.onPressed,
    super.key,
  });

  final ContactLinkModel link;
  final ScreenPalette palette;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: '${link.label}: ${link.value}',
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    link.label,
                    style: AppTypography.captionMedium.copyWith(
                      color: palette.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    link.value,
                    style: AppTypography.itemTitle.copyWith(
                      color: palette.text,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppIcon(
              type: AppIconType.arrowUpRight,
              color: palette.text,
              size: AppSizes.iconLink,
            ),
          ],
        ),
      ),
    );
  }
}
