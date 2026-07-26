import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../router/routes.dart';
import '../../data/dtos/login_request_dto.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final dto = LoginRequestDto(
      identity: _identityController.text.trim(),
      password: _passwordController.text,
    );

    final success = await ref.read(authControllerProvider.notifier).login(dto);

    if (!mounted) return;

    if (!success) {
      final errorMsg = ref.read(authControllerProvider).errorMessage ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.authenticating;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Welcome Back 👋',
                  style: AppTypography.displayHeadline(isDark: isDark),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to order your favorite meals',
                  style: AppTypography.bodyMedium(isDark: isDark),
                ),
                const SizedBox(height: 36),
                CustomTextField(
                  controller: _identityController,
                  label: 'Email or Phone Number',
                  hint: 'enter email or +880 phone',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your email or phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: '••••••••',
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: Text(
                      'Forgot Password?',
                      style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  text: 'Sign In',
                  isLoading: isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTypography.bodyMedium(isDark: isDark),
                    ),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.register),
                      child: Text(
                        'Register',
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
      ),
    );
  }
}
