import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';

class SiteNavLink extends StatefulWidget {
  const SiteNavLink({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  State<SiteNavLink> createState() => _SiteNavLinkState();
}

class _SiteNavLinkState extends State<SiteNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.xs,
            ),
            child: Text(
              widget.label,
              style: SiteTypography.labelMedium.copyWith(
                color: AppColors.navy,
                decoration: _hovered ? TextDecoration.underline : null,
                decorationColor: AppColors.navy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
