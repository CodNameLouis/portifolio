import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';

class TimelineDot extends StatelessWidget {
  const TimelineDot({required this.current, super.key});

  final bool current;

  @override
  Widget build(BuildContext context) {
    if (current) {
      return Container(
        width: AppSizes.timelineDotCurrent,
        height: AppSizes.timelineDotCurrent,
        decoration: const BoxDecoration(
          color: AppColors.terracotta,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.terracottaAlpha30,
              spreadRadius: AppSizes.timelineDotHalo,
            ),
          ],
        ),
      );
    }

    return Container(
      width: AppSizes.timelineDot,
      height: AppSizes.timelineDot,
      decoration: BoxDecoration(
        color: AppColors.navy,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.mustard,
          width: AppSizes.timelineDotBorder,
        ),
      ),
    );
  }
}
