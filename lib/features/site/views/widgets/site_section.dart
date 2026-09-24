import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';

class SiteSection extends StatelessWidget {
  const SiteSection({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.background,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = SiteMetrics.isCompact(constraints.maxWidth);
        final gutter = compact ? SiteMetrics.gutterCompact : SiteMetrics.gutter;

        final content = Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: SiteMetrics.maxWidth),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                gutter,
                padding.top,
                gutter,
                padding.bottom,
              ),
              child: child,
            ),
          ),
        );

        if (background == null) {
          return content;
        }

        return ColoredBox(color: background!, child: content);
      },
    );
  }
}
