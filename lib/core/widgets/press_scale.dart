import 'package:flutter/material.dart';

/// 2026 polish: spring press-scale micro-animation for cards and buttons.
/// Wraps a tappable widget and scales it down slightly while pressed.
class PressScale extends StatefulWidget {
  final Widget child;
  final double pressedScale;

  const PressScale({super.key, required this.child, this.pressedScale = 0.97});

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
