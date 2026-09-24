import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/shared/widgets/brand/logo_badge.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.palette,
    this.trailing,
    this.onLogoTap,
    super.key,
  });

  final ScreenPalette palette;
  final Widget? trailing;
  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.x3l,
        AppSpacing.pageHorizontal,
        AppSpacing.s,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LogoBadge(palette: palette, onTap: onLogoTap),
          ?trailing,
        ],
      ),
    );
  }
}
