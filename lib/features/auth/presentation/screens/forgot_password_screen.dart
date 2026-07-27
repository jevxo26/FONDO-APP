import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/text_link_button.dart';
import '../../../../router/routes.dart';
import '../../data/repositories/auth_repository.dart';

/// Forgot Password screen — static UI per `Login-Registration-Plan.md` §2.5.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  bool _isLoading = false;
  bool _sendSuccess = false;
  String? _fieldError;

  @override
  void dispose() {
    _identityController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetCode() async {
    setState(() {
      _fieldError = null;
    });
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final identity = _identityController.text.trim();
    try {
      final success = await ref.read(authRepositoryProvider).forgotPassword(identity);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _sendSuccess = success;
      });

      if (!success) {
        setState(() => _fieldError = 'Failed to request reset code');
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
        child: _sendSuccess ? _buildSuccessState(isDark) : _buildFormState(isDark),
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
            context.push('${AppRoutes.resetPassword}?target=${Uri.encodeComponent(target)}');
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

        // Error banner
        InlineErrorBanner(
          message: _fieldError,
          onDismiss: () => setState(() => _fieldError = null),
        ),

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
