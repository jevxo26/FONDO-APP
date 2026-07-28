import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'text_link_button.dart';

/// Countdown timer link widget for OTP/Reset resend per `Login-Registration-Plan.md` §3
class CountdownLink extends StatefulWidget {
  final String label;
  final int cooldownSeconds;
  final VoidCallback onResend;

  const CountdownLink({
    super.key,
    this.label = 'Resend code',
    this.cooldownSeconds = 45,
    required this.onResend,
  });

  @override
  CountdownLinkState createState() => CountdownLinkState();
}

class CountdownLinkState extends State<CountdownLink> {
  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 0;
  }

  /// Reset and restart the cooldown timer from the parent.
  void startCooldown() {
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _remainingSeconds = widget.cooldownSeconds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(1, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _handleResend() {
    if (_remainingSeconds == 0) {
      widget.onResend();
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_remainingSeconds > 0) {
      return Text(
        'Resend in ${_formatTime(_remainingSeconds)}',
        style: AppTypography.bodyMedium(isDark: isDark).copyWith(
          color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
        ),
      );
    }

    return TextLinkButton(
      text: widget.label,
      onPressed: _handleResend,
    );
  }
}
