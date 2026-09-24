import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({
    required this.greeting,
    required this.palette,
    super.key,
  });

  final String greeting;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return Text(
      greeting,
      style: AppTypography.subtitle.copyWith(color: palette.textSecondary),
    );
  }
}
