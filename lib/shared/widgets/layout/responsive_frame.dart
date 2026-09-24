import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';

class ResponsiveFrame extends StatelessWidget {
  const ResponsiveFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.responsiveMaxWidth,
        ),
        child: child,
      ),
    );
  }
}
