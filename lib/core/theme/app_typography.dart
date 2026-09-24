import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String displayFamily = 'BricolageGrotesque';
  static const String textFamily = 'Geist';

  static const TextStyle heroName = TextStyle(
    fontFamily: displayFamily,
    fontSize: 60,
    height: 0.92,
    letterSpacing: -2.1,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle contactTitle = TextStyle(
    fontFamily: displayFamily,
    fontSize: 46,
    height: 0.98,
    letterSpacing: -1.38,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: displayFamily,
    fontSize: 44,
    height: 1,
    letterSpacing: -1.32,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: displayFamily,
    fontSize: 26,
    height: 1.05,
    letterSpacing: -0.52,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle title = TextStyle(
    fontFamily: displayFamily,
    fontSize: 21,
    height: 1.15,
    letterSpacing: -0.315,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle itemTitle = TextStyle(
    fontFamily: displayFamily,
    fontSize: 18,
    letterSpacing: -0.18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle logo = TextStyle(
    fontFamily: displayFamily,
    fontSize: 16,
    letterSpacing: -0.32,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: textFamily,
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: textFamily,
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle button = TextStyle(
    fontFamily: textFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: textFamily,
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyTall = TextStyle(
    fontFamily: textFamily,
    fontSize: 14,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: textFamily,
    fontSize: 14,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: textFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle captionMedium = TextStyle(
    fontFamily: textFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle captionStrong = TextStyle(
    fontFamily: textFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: textFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: textFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle navLabelActive = TextStyle(
    fontFamily: textFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
}
