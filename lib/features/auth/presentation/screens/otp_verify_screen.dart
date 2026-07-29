import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/countdown_link.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../../../core/widgets/otp_input_row.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/dtos/otp_verify_dto.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// OTP Verify screen — §2.4. Wired to AuthController.
class OtpVerifyScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerifyScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final _otpKey = GlobalKey<OtpInputRowState>();
  final _countdownKey = GlobalKey<CountdownLinkState>();
  String _code = '';

  bool get _isCodeComplete => _code.length == 6;

  String _maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(phone.length - 3)}';
  }

  bool get _isEmail => widget.phone.contains('@');

  void _handleVerify() async {
    if (!_isCodeComplete) return;
    final dto = OtpVerifyDto(phone: widget.phone, code: _code);
    final success = await ref.read(authControllerProvider.notifier).verifyOtpAndAutoLogin(dto);
    if (!mounted) return;
    if (success) {
      context.go('/add-address');
    }
  }

  void _handleResend() {
    _countdownKey.currentState?.startCooldown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New verification code sent!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.authenticating;

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

          const SizedBox(height: 16),

          InlineErrorBanner(
            message: authState.errorMessage,
            onDismiss: () => ref.read(authControllerProvider.notifier).clearError(),
          ),

          const SizedBox(height: 12),

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
            isEnabled: _isCodeComplete && !isLoading,
            isLoading: isLoading,
            onPressed: _handleVerify,
          ),

          const SizedBox(height: 28),

          // §2.4: "Resend code — disabled with countdown"
          CountdownLink(
            key: _countdownKey,
            onResend: _handleResend,
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
