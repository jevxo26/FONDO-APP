import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/otp_input_row.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/text_link_button.dart';

/// OTP Verify screen — static UI per `Login-Registration-Plan.md` §2.4.
/// No API calls; dummy behavior only. Real controller wired in Step 14.
class OtpVerifyScreen extends StatefulWidget {
  final String phone;

  const OtpVerifyScreen({super.key, required this.phone});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpKey = GlobalKey<OtpInputRowState>();
  String _code = '';
  int _secondsRemaining = 60;
  Timer? _timer;

  bool get _isCodeComplete => _code.length == 6;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  String _maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(phone.length - 3)}';
  }

  bool get _isEmail => widget.phone.contains('@');

  void _handleVerify() {
    if (!_isCodeComplete) return;
    // Step 14 will replace this stub with the real controller call.
    setState(() {});
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      // Navigate to add address on simulated success
      context.go('/add-address');
    });
  }

  void _handleResend() {
    if (_secondsRemaining > 0) return;
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New verification code sent!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthScaffold(
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // §2.4: Headline — dynamic
          Text(
            _isEmail ? 'Verify your email' : 'Verify your number',
            style: AppTypography.headlineLarge(isDark: isDark),
          ),

          const SizedBox(height: 8),

          // §2.4: "We sent a 6-digit code to {masked phone/email}"
          Text(
            'We sent a 6-digit code to\n${_isEmail ? widget.phone : _maskPhone(widget.phone)}',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(isDark: isDark),
          ),

          const SizedBox(height: 36),

          // §2.4: "6 individual OTP boxes, auto-advance, gold border on active box"
          OtpInputRow(
            key: _otpKey,
            length: 6,
            onChanged: (val) => setState(() => _code = val),
            onCompleted: (val) {
              _code = val;
              _handleVerify();
            },
          ),

          const SizedBox(height: 32),

          // §2.4: "Verify (disabled until 6 digits entered)"
          PrimaryButton(
            text: 'Verify',
            isEnabled: _isCodeComplete,
            onPressed: _handleVerify,
          ),

          const SizedBox(height: 28),

          // §2.4: "Resend code — disabled with countdown"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_secondsRemaining > 0)
                Text(
                  'Resend in ${(_secondsRemaining ~/ 60)}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: AppTypography.bodyMedium(isDark: isDark),
                )
              else ...[
                Text(
                  "Didn't receive code? ",
                  style: AppTypography.bodyMedium(isDark: isDark),
                ),
                TextLinkButton(
                  text: 'Resend',
                  onPressed: _handleResend,
                ),
              ],
            ],
          ),

          const SizedBox(height: 28),

          // Demo data quick-fill
          GestureDetector(
            onTap: () => _otpKey.currentState?.setValue(mockOtpCode),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: AppRadii.full,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.smart_button_outlined,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Use Demo Data',
                    style: AppTypography.labelConvention(isDark: isDark)
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
