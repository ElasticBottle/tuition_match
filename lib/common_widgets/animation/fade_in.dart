import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum _AniProps { opacity, translateY }

class FadeIn extends StatelessWidget {
  const FadeIn(this.delay, this.child);

  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()
      ..add(
        _AniProps.opacity,
        Tween<double>(begin: 0.0, end: 1.0),
      )
      ..add(
        _AniProps.translateY,
        Tween<double>(begin: 100.0, end: 0.0),
      );

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: Duration(milliseconds: (75 * delay).round()),
      duration: Duration(milliseconds: 250),
      tween: tween,
      curve: Curves.easeOutBack,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset(0, value.get(_AniProps.translateY)),
          child: child,
        ),
      ),
    );
  }
}
