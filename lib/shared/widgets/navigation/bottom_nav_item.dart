import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon.dart';
import 'package:portfolio_luan/shared/widgets/navigation/nav_destination.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    required this.destination,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final NavDestination destination;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.mustard : AppColors.mutedGray;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: destination.label,
        child: InkWell(
          onTap: onPressed,
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: SizedBox(
            height: AppSizes.navItem,
            child: Column(
              children: [
                const SizedBox(
                  height: AppSizes.navDotTop + AppSizes.navDot + AppSpacing.xs,
                ),
                AppIcon(
                  type: destination.icon,
                  color: color,
                  size: AppSizes.iconNav,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  destination.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: selected
                      ? AppTypography.navLabelActive.copyWith(
                          color: AppColors.sand,
                        )
                      : AppTypography.navLabel.copyWith(
                          color: AppColors.mutedGray,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
