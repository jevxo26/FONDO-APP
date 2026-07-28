import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/countdown_link.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../../../core/widgets/otp_input_row.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../router/routes.dart';

/// Reset Password screen — static UI per `Login-Registration-Plan.md` §2.5.
/// No API calls; dummy behavior only. Real controller wired in Step 16.
class ResetPasswordScreen extends StatefulWidget {
  final String? target;

  const ResetPasswordScreen({super.key, this.target});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpKey = GlobalKey<OtpInputRowState>();
  final _countdownKey = GlobalKey<CountdownLinkState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _code = '';
  String? _apiError;
  bool _isLoading = false;

  bool get _isCodeComplete => _code.length == 6;

  void _handleResend() {
    _countdownKey.currentState?.startCooldown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New reset code sent!')),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (!_formKey.currentState!.validate()) return;
    if (!_isCodeComplete) return;
    setState(() => _apiError = null);
    // Step 16 will replace this stub with the real repository call.
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully! Please log in.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthScaffold(
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Headline
            Text(
              'Reset password',
              style: AppTypography.headlineLarge(isDark: isDark),
            ),

            const SizedBox(height: 8),

            // Subtext
            Text(
              'Enter the 6-digit code sent to ${widget.target ?? "your device"} and choose a new password.',
              style: AppTypography.bodyMedium(isDark: isDark),
            ),

            const SizedBox(height: 24),

            InlineErrorBanner(
              message: _apiError,
              onDismiss: () => setState(() => _apiError = null),
            ),

            const SizedBox(height: 8),

            // §2.5: "token field"
            Text(
              'Reset code',
              style: AppTypography.labelConvention(isDark: isDark),
            ),
            const SizedBox(height: 10),
            OtpInputRow(
              key: _otpKey,
              length: 6,
              onChanged: (val) => setState(() => _code = val),
              onCompleted: (val) => _code = val,
            ),

            const SizedBox(height: 16),

            CountdownLink(
              key: _countdownKey,
              onResend: _handleResend,
            ),

            const SizedBox(height: 24),

            // §2.5: "new password field"
            AppTextField(
              controller: _passwordController,
              label: 'New Password',
              hint: '••••••••',
              isPassword: true,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: isDark
                    ? AppColors.mutedForegroundDark
                    : AppColors.mutedForegroundLight,
              ),
              onChanged: (_) => setState(() {}),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Enter a new password';
                if (val.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _confirmPasswordController,
              label: 'Confirm New Password',
              hint: '••••••••',
              isPassword: true,
              textInputAction: TextInputAction.done,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: isDark
                    ? AppColors.mutedForegroundDark
                    : AppColors.mutedForegroundLight,
              ),
              onSubmitted: (_) => _handleResetPassword(),
              validator: (val) {
                if (val != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: 28),

            // §2.5: "Reset password" CTA
            PrimaryButton(
              text: 'Reset password',
              isLoading: _isLoading,
              onPressed: _handleResetPassword,
            ),

            const SizedBox(height: 16),

            // Demo data quick-fill
            Center(
              child: GestureDetector(
                onTap: () {
                  _otpKey.currentState?.setValue(mockOtpCode);
                  setState(() {
                    _passwordController.text = mockRegisterPassword;
                    _confirmPasswordController.text = mockRegisterPassword;
                  });
                },
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
            ),
          ],
        ),
      ),
    );
  }
}
