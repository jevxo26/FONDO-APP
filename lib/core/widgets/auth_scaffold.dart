import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable scaffold wrapper for all authentication screens per `Login-Registration-Plan.md` §3
class AuthScaffold extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? headerAction;

  const AuthScaffold({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.onBack,
    this.headerAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // Top ~40% subtle warm gold gradient wash behind hero area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(isDark ? 0.08 : 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Single Diamond Corner detail near top right (§7.3)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.35),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          // Main Content Area with SafeArea
          SafeArea(
            child: Column(
              children: [
                // Navigation Bar Header
                if (showBackButton || headerAction != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (showBackButton)
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                            ),
                            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                          )
                        else
                          const SizedBox(width: 48),
                        if (headerAction != null) headerAction!,
                      ],
                    ),
                  ),

                // Screen body content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
