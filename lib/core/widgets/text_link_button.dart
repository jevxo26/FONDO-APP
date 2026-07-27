import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Text link button matching `Login-Registration-Plan.md` §3
class TextLinkButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final Color? color;

  const TextLinkButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.color,
  });

  @override
  State<TextLinkButton> createState() => _TextLinkButtonState();
}

class _TextLinkButtonState extends State<TextLinkButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final linkColor = widget.color ?? AppColors.primary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _isPressed ? 0.6 : 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            widget.text,
            style: widget.style ??
                AppTypography.bodyMedium().copyWith(
                  color: linkColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
