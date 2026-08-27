import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Spring press-scale micro-animation for cards, buttons, and interactive elements.
/// Uses GSAP-grade spring overshoot physics with tactile haptic response.
class PressScale extends StatefulWidget {
  final Widget child;
  final double pressedScale;
  final VoidCallback? onTap;
  final HitTestBehavior behavior;

  const PressScale({
    super.key,
    required this.child,
    this.pressedScale = 0.96,
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  static const Curve _springCurve = Cubic(0.34, 1.56, 0.64, 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _pressed = true);
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (widget.onTap != null) {
          HapticFeedback.selectionClick();
          widget.onTap!();
        }
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: Duration(milliseconds: _pressed ? 90 : 280),
        curve: _pressed ? Curves.easeOutCubic : _springCurve,
        child: widget.child,
      ),
    );
  }
}
