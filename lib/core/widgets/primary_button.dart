import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

/// Primary CTA Button matching `DESIGN.md` §7.4 & `Login-Registration-Plan.md` §3
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  final double height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.height = 52.0,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = widget.backgroundColor ?? AppColors.primary;
    final effectiveFg = widget.textColor ?? AppColors.primaryForeground;
    final isClickable = widget.isEnabled && !widget.isLoading && widget.onPressed != null;

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: const Cubic(0.32, 0.72, 0, 1),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: GestureDetector(
          onTapDown: isClickable ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: isClickable ? (_) => setState(() => _isPressed = false) : null,
          onTapCancel: isClickable ? () => setState(() => _isPressed = false) : null,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isClickable ? effectiveBg : effectiveBg.withValues(alpha: 0.5),
              foregroundColor: effectiveFg,
              disabledBackgroundColor: effectiveBg.withValues(alpha: 0.4),
              disabledForegroundColor: effectiveFg.withValues(alpha: 0.5),
              elevation: 0,
              shape: const RoundedRectangleBorder(borderRadius: AppRadii.radius2xl),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            onPressed: isClickable ? widget.onPressed : null,
            child: widget.isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(effectiveFg),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        widget.icon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: AppTypography.buttonText().copyWith(
                          color: effectiveFg,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
