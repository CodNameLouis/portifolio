import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/shared/widgets/navigation/bottom_nav_item.dart';
import 'package:portfolio_luan/shared/widgets/navigation/nav_destination.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.palette,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final ScreenPalette palette;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.cardHorizontal,
        0,
        AppSpacing.cardHorizontal,
        AppSizes.navBottomMargin,
      ),
      child: Material(
        color: palette.navBackground,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: AppSizes.navBar,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.navPadding,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final slot = constraints.maxWidth / NavDestination.all.length;
                final dotLeft =
                    slot * currentIndex + (slot - AppSizes.navDot) / 2;

                return Stack(
                  children: [
                    Row(
                      children: [
                        for (
                          var index = 0;
                          index < NavDestination.all.length;
                          index++
                        )
                          BottomNavItem(
                            destination: NavDestination.all[index],
                            selected: index == currentIndex,
                            onPressed: () => onDestinationSelected(index),
                          ),
                      ],
                    ),
                    AnimatedPositioned(
                      duration: AppDurations.navIndicator,
                      curve: Curves.easeOutCubic,
                      left: dotLeft,
                      top: AppSizes.navDotTop,
                      child: Container(
                        width: AppSizes.navDot,
                        height: AppSizes.navDot,
                        decoration: const BoxDecoration(
                          color: AppColors.mustard,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
