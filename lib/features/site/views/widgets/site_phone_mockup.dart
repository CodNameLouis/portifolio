import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/site_metrics.dart';
import 'package:portfolio_luan/core/theme/site_typography.dart';

class SitePhoneMockup extends StatelessWidget {
  const SitePhoneMockup({
    required this.screenshot,
    required this.angleDegrees,
    super.key,
  });

  final String screenshot;
  final double angleDegrees;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angleDegrees * math.pi / 180,
      child: Container(
        width: SiteMetrics.phoneWidth,
        height: SiteMetrics.phoneHeight,
        padding: const EdgeInsets.all(SiteMetrics.phoneFrame),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: SiteMetrics.phoneRadius,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(22, 39, 47, 0.6),
              blurRadius: 60,
              spreadRadius: -24,
              offset: Offset(0, 30),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: SiteMetrics.phoneScreenRadius,
          child: ColoredBox(
            color: AppColors.sand,
            child: SizedBox.expand(
              child: Image.asset(
                screenshot,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    AppStrings.projectImageFallback,
                    textAlign: TextAlign.center,
                    style: SiteTypography.label.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
