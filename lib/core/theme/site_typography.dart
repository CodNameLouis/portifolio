import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';

abstract final class SiteTypography {
  static const TextStyle brand = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontSize: 22,
    letterSpacing: -0.44,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle heroName = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontSize: 96,
    height: 0.94,
    letterSpacing: -3.36,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontSize: 72,
    height: 1,
    letterSpacing: -2.52,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle contactTitle = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontSize: 88,
    height: 0.96,
    letterSpacing: -3.08,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle featuredName = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontSize: 52,
    height: 1,
    letterSpacing: -1.56,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle highlightTitle = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontSize: 40,
    height: 1,
    letterSpacing: -1.2,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle statTitle = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontSize: 28,
    letterSpacing: -0.56,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontSize: 28,
    height: 1.15,
    letterSpacing: -0.56,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle projectName = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontSize: 26,
    letterSpacing: -0.39,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle lead = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 21,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 19,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 16,
    height: 1.55,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle groupLabel = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle label = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelStrong = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headerButton = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle footer = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle chip = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: AppTypography.textFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
}
