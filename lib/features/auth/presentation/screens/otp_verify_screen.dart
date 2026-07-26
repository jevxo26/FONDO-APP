import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/dtos/otp_verify_dto.dart';
import '../../data/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';
import '../widgets/pin_code_input.dart';

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
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _handleVerify() async {
    if (_code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 6 digits of the code')),
      );
      return;
    }

    final dto = OtpVerifyDto(phone: widget.phone, code: _code);
    final success = await ref.read(authControllerProvider.notifier).verifyOtpAndAutoLogin(dto);

    if (!mounted) return;

    if (!success) {
      final errorMsg = ref.read(authControllerProvider).errorMessage ?? 'OTP Verification failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: AppColors.error,
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend code: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.authenticating;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Enter 6-Digit Code',
                style: AppTypography.titleLarge(isDark: isDark),
              ),
              const SizedBox(height: 8),
              Text(
                'We sent a verification code to\n${widget.phone}',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium(isDark: isDark),
              ),
              const SizedBox(height: 36),
              PinCodeInput(
                length: 6,
                onChanged: (val) => _code = val,
                onCompleted: (val) {
                  _code = val;
                  _handleVerify();
                },
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Verify & Continue',
                isLoading: isLoading,
                onPressed: _handleVerify,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _secondsRemaining > 0
                        ? 'Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')} '
                        : "Didn't receive code? ",
                    style: AppTypography.bodyMedium(isDark: isDark),
                  ),
                  if (_secondsRemaining == 0)
                    GestureDetector(
                      onTap: _handleResend,
                      child: Text(
                        'Resend',
                        style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
