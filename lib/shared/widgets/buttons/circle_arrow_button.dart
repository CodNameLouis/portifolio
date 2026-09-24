import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon.dart';
import 'package:portfolio_luan/shared/widgets/icons/app_icon_type.dart';

class CircleArrowButton extends StatelessWidget {
  const CircleArrowButton({
    required this.color,
    required this.borderColor,
    this.onPressed,
    super.key,
  });

  final Color color;
  final Color borderColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final shape = CircleBorder(
      side: BorderSide(color: borderColor, width: AppSizes.hairline),
    );

    return SizedBox(
      width: AppSizes.minTouchTarget,
      height: AppSizes.minTouchTarget,
      child: Center(
        child: Material(
          color: Colors.transparent,
          shape: shape,
          child: InkWell(
            onTap: onPressed,
            customBorder: shape,
            child: SizedBox(
              width: AppSizes.circleArrow,
              height: AppSizes.circleArrow,
              child: Center(
                child: AppIcon(type: AppIconType.arrowUpRight, color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
