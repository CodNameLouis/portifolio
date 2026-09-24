import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';

class HomeNameTitle extends StatelessWidget {
  const HomeNameTitle({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.palette,
    super.key,
  });

  final String firstName;
  final String lastName;
  final String role;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: '$firstName $lastName, $role',
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '$firstName '),
              TextSpan(
                text: lastName,
                style: const TextStyle(color: AppColors.terracotta),
              ),
            ],
          ),
          style: AppTypography.heroName.copyWith(color: palette.text),
        ),
      ),
    );
  }
}
