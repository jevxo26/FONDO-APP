import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';

/// Splash / Bootstrap screen per `Login-Registration-Plan.md` §2.1 and Step 3.
/// Static UI only — token-check logic (Step 15) is added later.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Splash always renders on the warm cream light background
    // regardless of system theme — first impression moment.
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Subtle warm gold radial wash from top — §2 spec "top ~40% gradient"
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.5),
                  radius: 1.0,
                  colors: [
                    Color(0x14CEA359), // primary ~8%
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Diamond corner detail — §7.3
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 28,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          // Centre content — logo + wordmark
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo mark: gold circle with a subtle card shadow
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.card,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      size: 42,
                      color: AppColors.primaryForeground,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // FONDO wordmark — Fraunces 32/700, §3 headline-lg
                Text(
                  'FONDO',
                  style: AppTypography.headlineLarge().copyWith(
                    letterSpacing: 4,
                    color: AppColors.foregroundLight,
                  ),
                ),

                const SizedBox(height: 10),

                // Gold divider — §7.5
                Container(
                  width: 48,
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.primary,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline — Inter 12 muted
                Text(
                  'Healthy, scheduled & customizable',
                  style: AppTypography.small(isDark: false).copyWith(
                    color: AppColors.mutedForegroundLight,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 52),

                // Loading indicator — thin gold ring
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom brand pill badge — §7.9 label convention
          Positioned(
            bottom: 36 + MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: AppRadii.full,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  'SMART SUBSCRIPTION',
                  style: AppTypography.labelConvention().copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
