import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

/// 6-digit OTP Input Row widget per `Login-Registration-Plan.md` §3
class OtpInputRow extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool hasError;

  const OtpInputRow({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.onCompleted,
    this.hasError = false,
  });

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  void _onFieldChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste of multiple digits
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < widget.length; i++) {
        if (i < digits.length) {
          _controllers[i].text = digits[i];
        }
      }
      final nextIndex = digits.length < widget.length ? digits.length : widget.length - 1;
      _focusNodes[nextIndex].requestFocus();
    } else if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    final code = _otpValue;
    widget.onChanged(code);
    if (code.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!(code);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          width: 46,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onKeyEvent(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                color: widget.hasError
                    ? AppColors.destructive
                    : (isDark ? AppColors.foregroundDark : AppColors.foregroundLight),
              ),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                border: OutlineInputBorder(
                  borderRadius: AppRadii.lg,
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadii.lg,
                  borderSide: BorderSide(
                    color: widget.hasError
                        ? AppColors.destructive
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: widget.hasError ? 1.5 : 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadii.lg,
                  borderSide: BorderSide(
                    color: widget.hasError ? AppColors.destructive : AppColors.ring,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (val) => _onFieldChanged(index, val),
            ),
          ),
        ),
      ),
    );
  }
}
