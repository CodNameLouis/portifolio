import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/theme/app_spacing.dart';
import 'package:portfolio_luan/core/theme/app_typography.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';
import 'package:portfolio_luan/shared/widgets/buttons/outline_pill_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    required this.palette,
    this.onRetry,
    super.key,
  });

  final String message;
  final ScreenPalette palette;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: palette.text),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              OutlinePillButton(
                label: AppStrings.retry,
                foreground: palette.text,
                onPressed: onRetry!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
