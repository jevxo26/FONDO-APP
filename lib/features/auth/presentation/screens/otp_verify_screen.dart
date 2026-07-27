import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/otp_input_row.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/text_link_button.dart';
import '../../data/dtos/otp_verify_dto.dart';
import '../../data/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// OTP Verify screen — static UI per `Login-Registration-Plan.md` §2.4.
class OtpVerifyScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerifyScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  String _code = '';
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _hasError = false;

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

  Future<void> _handleVerify() async {
    if (!_isCodeComplete) return;

    setState(() => _hasError = false);

    final dto = OtpVerifyDto(phone: widget.phone, code: _code);
    final success = await ref
        .read(authControllerProvider.notifier)
        .verifyOtpAndAutoLogin(dto);

    if (!mounted) return;

    if (!success) {
      setState(() => _hasError = true);
      final errorMsg =
          ref.read(authControllerProvider).errorMessage ?? 'Verification failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _handleResend() async {
    if (_secondsRemaining > 0) return;

    try {
      await ref.read(authRepositoryProvider).sendOtp(widget.phone);
      _startTimer();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New verification code sent!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend code: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.authenticating;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthScaffold(
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // §2.4: Headline — dynamic "Verify your number" / "Verify your email"
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
            length: 6,
            hasError: _hasError,
            onChanged: (val) {
              setState(() {
                _code = val;
                _hasError = false;
              });
            },
            onCompleted: (val) {
              _code = val;
              _handleVerify();
            },
          ),

          const SizedBox(height: 32),

          // §2.4: "Verify (disabled until 6 digits entered)"
          PrimaryButton(
            text: 'Verify',
            isLoading: isLoading,
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
        ],
      ),
    );
  }
}
