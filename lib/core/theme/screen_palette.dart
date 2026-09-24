import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';

class ScreenPalette {
  const ScreenPalette({
    required this.background,
    required this.text,
    required this.textSecondary,
    required this.logoBackground,
    required this.logoText,
    required this.navBackground,
    required this.divider,
    required this.overlayStyle,
  });

  final Color background;
  final Color text;
  final Color textSecondary;
  final Color logoBackground;
  final Color logoText;
  final Color navBackground;
  final Color divider;
  final SystemUiOverlayStyle overlayStyle;

  static const ScreenPalette light = ScreenPalette(
    background: AppColors.sand,
    text: AppColors.navy,
    textSecondary: AppColors.slate,
    logoBackground: AppColors.navy,
    logoText: AppColors.sand,
    navBackground: AppColors.navy,
    divider: AppColors.navyAlpha18,
    overlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  static const ScreenPalette dark = ScreenPalette(
    background: AppColors.navy,
    text: AppColors.sand,
    textSecondary: AppColors.beige,
    logoBackground: AppColors.sand,
    logoText: AppColors.navy,
    navBackground: AppColors.navyDeep,
    divider: AppColors.sandAlpha18,
    overlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  static const ScreenPalette accent = ScreenPalette(
    background: AppColors.terracotta,
    text: AppColors.white,
    textSecondary: AppColors.white,
    logoBackground: AppColors.sand,
    logoText: AppColors.navy,
    navBackground: AppColors.navy,
    divider: AppColors.whiteAlpha32,
    overlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  static const List<ScreenPalette> byTab = [light, light, light, dark, accent];

  static ScreenPalette forIndex(int index) => byTab[index];
}
