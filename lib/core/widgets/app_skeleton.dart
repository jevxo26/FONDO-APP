import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppSkeleton extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const AppSkeleton({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = widget.baseColor ??
        (isDark ? AppColors.cardDark.withValues(alpha: 0.5) : AppColors.mutedLight);
    final highlight = widget.highlightColor ??
        (isDark ? AppColors.cardDark : AppColors.mutedForegroundLight.withValues(alpha: 0.15));

    return _ShimmerMask(
      animation: _animation,
      baseColor: base,
      highlightColor: highlight,
      child: widget.child,
    );
  }
}

class _ShimmerMask extends StatelessWidget {
  final Animation<double> animation;
  final Color baseColor;
  final Color highlightColor;
  final Widget child;

  const _ShimmerMask({
    required this.animation,
    required this.baseColor,
    required this.highlightColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                baseColor,
                highlightColor,
                baseColor,
                baseColor,
              ],
              stops: [
                animation.value - 0.4,
                animation.value - 0.2,
                animation.value,
                animation.value + 0.2,
                animation.value + 0.4,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }
}
