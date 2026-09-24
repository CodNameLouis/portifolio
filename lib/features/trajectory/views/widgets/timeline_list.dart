import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/features/trajectory/models/experience_model.dart';
import 'package:portfolio_luan/features/trajectory/views/widgets/timeline_item.dart';

class TimelineList extends StatelessWidget {
  const TimelineList({
    required this.experiences,
    required this.palette,
    super.key,
  });

  final List<ExperienceModel> experiences;
  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.x5l,
        AppSpacing.pageHorizontal,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < experiences.length; index++)
            TimelineItem(
              experience: experiences[index],
              isLast: index == experiences.length - 1,
              palette: palette,
            ),
        ],
      ),
    );
  }
}
