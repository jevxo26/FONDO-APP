import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../../../core/widgets/otp_input_row.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../router/routes.dart';
import '../../data/repositories/auth_repository.dart';

/// Reset Password screen — static UI per `Login-Registration-Plan.md` §2.5.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? target;

  const ResetPasswordScreen({super.key, this.target});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _code = '';
  bool _isLoading = false;
  String? _fieldError;

  bool get _isCodeComplete => _code.length == 6;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    setState(() => _fieldError = null);
    if (!_formKey.currentState!.validate()) return;

    if (!_isCodeComplete) {
      setState(() => _fieldError = 'Enter all 6 digits of the reset code');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await ref.read(authRepositoryProvider).resetPassword(
            code: _code,
            newPassword: _passwordController.text,
            identity: widget.target,
          );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully! Please log in.'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(AppRoutes.login);
      } else {
        setState(() => _fieldError = 'Password reset failed');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _fieldError = e.toString().replaceAll('Exception: ', '').replaceAll('AppException: ', '');
      });
    }
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

            const SizedBox(height: 32),

            // Error banner
            InlineErrorBanner(
              message: _fieldError,
              onDismiss: () => setState(() => _fieldError = null),
            ),

            // §2.5: "token (usually deep-linked, but include a manual paste field as fallback)"
            Text(
              'Reset code',
              style: AppTypography.labelConvention(isDark: isDark),
            ),
            const SizedBox(height: 10),
            OtpInputRow(
              length: 6,
              onChanged: (val) {
                setState(() {
                  _code = val;
                  _fieldError = null;
                });
              },
              onCompleted: (val) => _code = val,
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
              validator: (val) {
                if (val == null || val.isEmpty) return 'Enter a new password';
                if (val.length < 6) return 'Password must be at least 6 characters';
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

            // §2.5: "Reset password" CTA → success → back to Login
            PrimaryButton(
              text: 'Reset password',
              isLoading: _isLoading,
              onPressed: _handleResetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
