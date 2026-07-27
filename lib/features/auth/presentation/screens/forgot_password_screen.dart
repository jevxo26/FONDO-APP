import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/text_link_button.dart';
import '../../../../router/routes.dart';

/// Forgot Password screen — static UI per `Login-Registration-Plan.md` §2.5.
/// No API calls; dummy behavior only. Real controller wired in Step 16.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  bool _isLoading = false;
  bool _sendSuccess = false;

  @override
  void dispose() {
    _identityController.dispose();
    super.dispose();
  }

  void _handleSendResetCode() {
    if (!_formKey.currentState!.validate()) return;
    // Step 16 will replace this stub with the real repository call.
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _sendSuccess = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthScaffold(
      showBackButton: true,
      child: Form(
        key: _formKey,
        child:
            _sendSuccess ? _buildSuccessState(isDark) : _buildFormState(isDark),
      ),
    );
  }

  /// §2.5: confirmation state — "Check your email"
  Widget _buildSuccessState(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        // Success icon
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 32,
              color: AppColors.success,
            ),
          ),
        ),

        const SizedBox(height: 28),

        Center(
          child: Text(
            'Check your email',
            style: AppTypography.headlineLarge(isDark: isDark),
          ),
        ),

        const SizedBox(height: 12),

        Center(
          child: Text(
            'We\'ve sent a 6-digit reset code to\n${_identityController.text.trim()}',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(isDark: isDark),
          ),
        ),

        const SizedBox(height: 32),

        PrimaryButton(
          text: 'Reset password',
          onPressed: () {
            final target = _identityController.text.trim();
            context.push(
              '${AppRoutes.resetPassword}?target=${Uri.encodeComponent(target)}',
            );
          },
        ),

        const SizedBox(height: 24),

        Center(
          child: TextLinkButton(
            text: 'Back to login',
            onPressed: () => context.pop(),
          ),
        ),
      ],
    );
  }

  /// §2.5: single email field, "Send reset link" CTA
  Widget _buildFormState(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        // Headline
        Text(
          'Forgot password?',
          style: AppTypography.headlineLarge(isDark: isDark),
        ),

        const SizedBox(height: 8),

        // Subtext
        Text(
          'Enter your email or phone number and we\'ll send you a 6-digit reset code.',
          style: AppTypography.bodyMedium(isDark: isDark),
        ),

        const SizedBox(height: 32),

        // §2.5: "single email field"
        AppTextField(
          controller: _identityController,
          label: 'Email or Phone Number',
          hint: 'john@example.com or +88017...',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email_outlined,
            size: 20,
            color: isDark
                ? AppColors.mutedForegroundDark
                : AppColors.mutedForegroundLight,
          ),
          onSubmitted: (_) => _handleSendResetCode(),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'Enter your registered email or phone';
            }
            return null;
          },
        ),

        const SizedBox(height: 28),

        // §2.5: "Send reset link" CTA
        PrimaryButton(
          text: 'Send reset code',
          isLoading: _isLoading,
          onPressed: _handleSendResetCode,
        ),
      ],
    );
  }
}
