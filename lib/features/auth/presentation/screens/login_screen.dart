import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/text_link_button.dart';
import '../../../../router/routes.dart';

/// Login screen — §2.2. Static UI with hardcoded demo credentials.
/// No API, no controller. test@fondo.com / test123 succeeds.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();

  static const _demoEmail = 'test@fondo.com';
  static const _demoPassword = 'test123';

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

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final email = _identityController.text.trim();
      final password = _passwordController.text;

      if (email == _demoEmail && password == _demoPassword) {
        context.go('/home');
      } else {
        setState(() {
          _fieldError = 'Invalid email or password. Please try again.';
        });
      }
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
                if (val.length < 6) {
                  return 'Password must be at least 6 characters';
                }
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

            const SizedBox(height: 16),

            // Demo data quick-fill
            Center(
              child: GestureDetector(
                onTap: () => setState(() {
                  _identityController.text = _demoEmail;
                  _passwordController.text = _demoPassword;
                }),
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
