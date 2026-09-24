import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/constants/app_durations.dart';
import 'package:portfolio_luan/core/theme/app_sizes.dart';

class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({required this.child, this.order = 0, super.key});

  final Widget child;
  final int order;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final Duration _delay = AppDurations.entranceStagger * widget.order;
  late final Duration _total = AppDurations.entrance + _delay;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _total,
  )..forward();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      _delay.inMicroseconds / _total.inMicroseconds,
      1,
      curve: Curves.easeOut,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0, AppSizes.entranceSlide * (1 - _animation.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
