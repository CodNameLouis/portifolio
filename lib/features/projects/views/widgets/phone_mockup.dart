import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_radius.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';

class PhoneMockup extends StatelessWidget {
  const PhoneMockup({required this.screenshot, super.key});

  final String screenshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.phoneWidth,
      height: AppSizes.phoneHeight,
      padding: const EdgeInsets.all(AppSizes.phoneFrame),
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: AppRadius.phoneOuterAll,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.phoneScreenAll,
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
                  style: AppTypography.caption.copyWith(color: AppColors.slate),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
