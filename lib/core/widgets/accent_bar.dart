import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// AccentBar – a thin colored bar placed on one edge of a container.
/// Implements the design spec §7.6.
class AccentBar extends StatelessWidget {
  const AccentBar({
    super.key,
    this.thickness = 4.0,
    this.side = Axis.vertical,
    this.alignment = Alignment.topLeft,
    this.colorStart = AppColors.primary,
    this.colorEnd = AppColors.primary,
  });

  /// Thickness of the bar in logical pixels.
  final double thickness;

  /// Axis.vertical -> left/right bar, Axis.horizontal -> top/bottom bar.
  final Axis side;

  /// Alignment of the bar within its parent.
  final Alignment alignment;

  /// Gradient start color (default primary).
  final Color colorStart;

  /// Gradient end color (default primary with 60% opacity).
  final Color colorEnd;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [colorStart, colorEnd.withValues(alpha: 0.6)],
    );

    return Align(
      alignment: alignment,
      child: Container(
        width: side == Axis.vertical ? thickness : double.infinity,
        height: side == Axis.horizontal ? thickness : double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: side == Axis.vertical
              ? const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                ),
        ),
      ),
    );
  }
}
