import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../router/routes.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _identityController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final identity = _identityController.text.trim();
    try {
      final success = await ref.read(authRepositoryProvider).forgotPassword(identity);
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        context.push('${AppRoutes.resetPassword}?target=${Uri.encodeComponent(identity)}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to request reset code'), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('AppException: ', '')), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset Your Password 🔒',
                  style: AppTypography.displayHeadline(isDark: isDark),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your registered email address or phone number to receive a 6-digit reset code.',
                  style: AppTypography.bodyMedium(isDark: isDark),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _identityController,
                  label: 'Email or Phone Number',
                  hint: 'john@example.com or +88017...',
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your registered email or phone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  text: 'Send Reset Code',
                  isLoading: _isLoading,
                  onPressed: _handleSendResetCode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
