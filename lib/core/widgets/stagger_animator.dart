import 'package:flutter/material.dart';

/// GSAP-style staggered cascading entrance widget.
/// Translates upward with subtle scaling and alpha fade with index-based stagger delay.
class StaggerAnimator extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration duration;
  final Duration staggerDelay;
  final double slideOffset;
  final Curve curve;

  const StaggerAnimator({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 480),
    this.staggerDelay = const Duration(milliseconds: 60),
    this.slideOffset = 24.0,
    this.curve = const Cubic(0.16, 1.0, 0.3, 1.0), // Power3.out equivalent
  });

  @override
  State<StaggerAnimator> createState() => _StaggerAnimatorState();
}

class _StaggerAnimatorState extends State<StaggerAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _slideAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _slideAnim = Tween<double>(begin: widget.slideOffset, end: 0.0).animate(curved);
    _scaleAnim = Tween<double>(begin: 0.96, end: 1.0).animate(curved);

    final totalDelay = widget.staggerDelay * widget.index;
    if (totalDelay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(totalDelay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnim.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, _slideAnim.value),
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
