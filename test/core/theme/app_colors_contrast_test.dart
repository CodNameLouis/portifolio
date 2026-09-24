import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';

double _channel(double value) {
  return value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
}

double _luminance(Color color) {
  return 0.2126 * _channel(color.r) +
      0.7152 * _channel(color.g) +
      0.0722 * _channel(color.b);
}

double contrast(Color a, Color b) {
  final first = _luminance(a);
  final second = _luminance(b);
  final lighter = math.max(first, second);
  final darker = math.min(first, second);

  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  const minimoAA = 4.5;

  test('texto e fundo de cada paleta passam no WCAG AA', () {
    for (final palette in ScreenPalette.byTab) {
      expect(
        contrast(palette.text, palette.background),
        greaterThanOrEqualTo(minimoAA),
      );
      expect(
        contrast(palette.textSecondary, palette.background),
        greaterThanOrEqualTo(minimoAA),
      );
      expect(
        contrast(palette.logoText, palette.logoBackground),
        greaterThanOrEqualTo(minimoAA),
      );
    }
  });

  test('a bottom nav passa no WCAG AA nos dois fundos', () {
    for (final fundo in [AppColors.navy, AppColors.navyDeep]) {
      expect(contrast(AppColors.sand, fundo), greaterThanOrEqualTo(minimoAA));
      expect(
        contrast(AppColors.mutedGray, fundo),
        greaterThanOrEqualTo(minimoAA),
      );
      expect(
        contrast(AppColors.mustard, fundo),
        greaterThanOrEqualTo(minimoAA),
      );
    }
  });

  test('chips e botões passam no WCAG AA', () {
    expect(
      contrast(AppColors.navy, AppColors.mustard),
      greaterThanOrEqualTo(minimoAA),
    );
    expect(
      contrast(AppColors.white, AppColors.terracotta),
      greaterThanOrEqualTo(minimoAA),
    );
    expect(
      contrast(AppColors.navy, AppColors.sandLight),
      greaterThanOrEqualTo(minimoAA),
    );
    expect(
      contrast(AppColors.navy, AppColors.sand),
      greaterThanOrEqualTo(minimoAA),
    );
  });
}
