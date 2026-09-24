import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/shared/widgets/layout/responsive_frame.dart';
import 'package:portfolio_luan/shared/widgets/navigation/bottom_nav_bar.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final palette = ScreenPalette.forIndex(navigationShell.currentIndex);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navSpace = AppSizes.navBar + AppSizes.navBottomMargin + bottomInset;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: palette.overlayStyle,
      child: AnimatedContainer(
        duration: AppDurations.paletteTransition,
        color: palette.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ResponsiveFrame(
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: navSpace),
                    child: navigationShell,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: BottomNavBar(
                        palette: palette,
                        currentIndex: navigationShell.currentIndex,
                        onDestinationSelected: _goToBranch,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _goToBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
