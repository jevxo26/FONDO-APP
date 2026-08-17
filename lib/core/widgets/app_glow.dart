import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 2026 polish: ambient gold glow orbs placed behind screen content.
/// Soft radial gradients of the primary (#CEA359) at ~5% opacity.
class GlowOrbs extends StatelessWidget {
  final bool large;

  const GlowOrbs({super.key, this.large = false});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -80,
            right: -70,
            child: _orb(large ? 200 : 160, 0.05),
          ),
          Positioned(
            bottom: -50,
            left: -80,
            child: _orb(large ? 220 : 180, 0.045),
          ),
          Positioned(top: 280, left: -60, child: _orb(120, 0.04)),
        ],
      ),
    );
  }

  Widget _orb(double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.primary.withValues(alpha: alpha),
            AppColors.primary.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
