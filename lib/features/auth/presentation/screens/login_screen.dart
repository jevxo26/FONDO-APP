import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/text_link_button.dart';
import '../../../../router/routes.dart';

/// Login screen — static UI per `Login-Registration-Plan.md` §2.2, Step 3.
/// No API calls; dummy validators only. Real controller wired in Step 12.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();

  // UI-only state — no API call
  String? _fieldError;
  bool _isLoading = false;

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _fieldError = null);
    if (!_formKey.currentState!.validate()) return;
    // Step 12 will replace this stub with the real controller call.
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Logo mark — small, centred
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 22,
                  color: AppColors.primaryForeground,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Headline — Fraunces 32/700
            Text(
              'Welcome back',
              style: AppTypography.headlineLarge(isDark: isDark),
            ),

            const SizedBox(height: 8),

            // Subtext — Inter 14, muted
            Text(
              'Log in to continue your meal plan',
              style: AppTypography.bodyMedium(isDark: isDark),
            ),

            const SizedBox(height: 32),

            // API error banner — sits above fields, hidden until set
            InlineErrorBanner(
              message: _fieldError,
              onDismiss: () => setState(() => _fieldError = null),
            ),

            // Email or Phone (smart detect — no separate toggle)
            AppTextField(
              controller: _identityController,
              label: 'Email or Phone',
              hint: 'name@domain.com or +8801…',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: isDark
                    ? AppColors.mutedForegroundDark
                    : AppColors.mutedForegroundLight,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Enter your email or phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Password with show/hide toggle built into AppTextField
            AppTextField(
              controller: _passwordController,
              label: 'Password',
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
              validator: (val) {
                if (val == null || val.isEmpty) return 'Enter your password';
                if (val.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
              onSubmitted: (_) => _handleLogin(),
            ),

            const SizedBox(height: 12),

            // Forgot password — right-aligned gold link
            Align(
              alignment: Alignment.centerRight,
              child: TextLinkButton(
                text: 'Forgot password?',
                onPressed: () => context.push(AppRoutes.forgotPassword),
              ),
            ),

            const SizedBox(height: 28),

            // Primary CTA — gold, radius-2xl, spring press
            PrimaryButton(
              text: 'Log in',
              isLoading: _isLoading,
              onPressed: _handleLogin,
            ),

            const SizedBox(height: 28),

            // Secondary link row
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'New to FONDO? ',
                    style: AppTypography.bodyMedium(isDark: isDark),
                  ),
                  TextLinkButton(
                    text: 'Create account',
                    onPressed: () => context.push(AppRoutes.register),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
