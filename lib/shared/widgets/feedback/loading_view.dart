import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/screen_palette.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({required this.palette, super.key});

  final ScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: palette.text));
  }
}
