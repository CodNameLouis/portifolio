import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.textFamily,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.light(
      primary: AppColors.terracotta,
      onPrimary: AppColors.white,
      secondary: AppColors.mustard,
      onSecondary: AppColors.navy,
      surface: AppColors.sand,
      onSurface: AppColors.navy,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTypography.heroName,
      displayMedium: AppTypography.contactTitle,
      displaySmall: AppTypography.pageTitle,
      headlineMedium: AppTypography.headline,
      titleLarge: AppTypography.title,
      titleMedium: AppTypography.itemTitle,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.caption,
      labelLarge: AppTypography.button,
      labelSmall: AppTypography.navLabel,
    ).apply(bodyColor: AppColors.navy, displayColor: AppColors.navy),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.navy,
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.sand),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
