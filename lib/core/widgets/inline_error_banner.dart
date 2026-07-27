import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

/// Top-of-form error display banner matching `Login-Registration-Plan.md` §3
class InlineErrorBanner extends StatelessWidget {
  final String? message;
  final VoidCallback? onDismiss;

  const InlineErrorBanner({
    super.key,
    this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.destructive.withOpacity(isDark ? 0.15 : 0.08),
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: AppColors.destructive.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 20,
            color: AppColors.destructive,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message!,
              style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                color: AppColors.destructive,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.destructive,
              ),
            ),
        ],
      ),
    );
  }
}
