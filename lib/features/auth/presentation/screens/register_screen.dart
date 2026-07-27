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
import '../../data/dtos/register_request_dto.dart';
import '../../data/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// Register screen — static UI per `Login-Registration-Plan.md` §2.3.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _fieldError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() => _fieldError = null);
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final name =
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
            .trim();

    final dto = RegisterRequestDto(
      name: name,
      email: _emailController.text.trim(),
      phone: phone,
      password: _passwordController.text,
    );

    final success =
        await ref.read(authControllerProvider.notifier).register(dto);

    if (!mounted) return;

    if (success) {
      await ref.read(authRepositoryProvider).sendOtp(phone);
      if (!mounted) return;
      context.push('${AppRoutes.otpVerify}?phone=${Uri.encodeComponent(phone)}');
    } else {
      final errorMsg =
          ref.read(authControllerProvider).errorMessage ?? 'Registration failed';
      setState(() => _fieldError = errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.authenticating;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthScaffold(
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Headline — §2.3: "Create your account"
            Text(
              'Create your account',
              style: AppTypography.headlineLarge(isDark: isDark),
            ),

            const SizedBox(height: 8),

            // Subtext — §2.3: "Healthy meals, on your schedule"
            Text(
              'Healthy meals, on your schedule',
              style: AppTypography.bodyMedium(isDark: isDark),
            ),

            const SizedBox(height: 32),

            // API error banner
            InlineErrorBanner(
              message: _fieldError,
              onDismiss: () => setState(() => _fieldError = null),
            ),

            // §2.3: "First name, Last name (two-up row)"
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    hint: 'John',
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.mutedForegroundDark
                          : AppColors.mutedForegroundLight,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    hint: 'Doe',
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.mutedForegroundDark
                          : AppColors.mutedForegroundLight,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // §2.3: Phone
            AppTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+8801700000000',
              keyboardType: TextInputType.phone,
              prefixIcon: Icon(
                Icons.phone_outlined,
                size: 20,
                color: isDark
                    ? AppColors.mutedForegroundDark
                    : AppColors.mutedForegroundLight,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Enter your phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // §2.3: Email
            AppTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'john@example.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.email_outlined,
                size: 20,
                color: isDark
                    ? AppColors.mutedForegroundDark
                    : AppColors.mutedForegroundLight,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Enter your email';
                }
                if (!val.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // §2.3: "Password with a lightweight strength hint"
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
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _handleRegister(),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Enter a password';
                if (val.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),

            // §2.3: "simple met/unmet checklist under the field"
            const SizedBox(height: 8),
            _PasswordStrengthHint(
              password: _passwordController.text,
              isDark: isDark,
            ),

            const SizedBox(height: 28),

            // §2.3: CTA "Create account"
            PrimaryButton(
              text: 'Create account',
              isLoading: isLoading,
              onPressed: _handleRegister,
            ),

            const SizedBox(height: 28),

            // §2.3: "Already have an account? Log in"
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.bodyMedium(isDark: isDark),
                  ),
                  TextLinkButton(
                    text: 'Log in',
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // §2.3: "By continuing you agree to our Terms & Privacy"
            Center(
              child: Text(
                'By continuing you agree to our Terms & Privacy',
                style: AppTypography.small(isDark: isDark),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// §2.3: "simple met/unmet checklist under the field, not a colored strength bar"
class _PasswordStrengthHint extends StatelessWidget {
  final String password;
  final bool isDark;

  const _PasswordStrengthHint({required this.password, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final hasMinLength = password.length >= 6;

    return Row(
      children: [
        Icon(
          hasMinLength ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
          size: 14,
          color: hasMinLength
              ? AppColors.success
              : (isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight),
        ),
        const SizedBox(width: 6),
        Text(
          'At least 6 characters',
          style: AppTypography.small(isDark: isDark).copyWith(
            color: hasMinLength
                ? AppColors.success
                : (isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight),
          ),
        ),
      ],
    );
  }
}
