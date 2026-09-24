import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';

class DividedColumn extends StatelessWidget {
  const DividedColumn({
    required this.children,
    required this.dividerColor,
    this.itemPadding = EdgeInsets.zero,
    this.spacingAbove = 0,
    this.spacingBelow = 0,
    super.key,
  });

  final List<Widget> children;
  final Color dividerColor;
  final EdgeInsets itemPadding;
  final double spacingAbove;
  final double spacingBelow;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    for (var index = 0; index < children.length; index++) {
      final isFirst = index == 0;

      if (!isFirst && spacingAbove > 0) {
        items.add(SizedBox(height: spacingAbove));
      }

      items.add(
        Container(
          padding: itemPadding.copyWith(
            top: itemPadding.top + (isFirst ? 0 : spacingBelow),
          ),
          decoration: isFirst
              ? null
              : BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: dividerColor,
                      width: AppSizes.hairline,
                    ),
                  ),
                ),
          child: children[index],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}
