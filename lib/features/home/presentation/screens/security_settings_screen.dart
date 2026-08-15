import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/skeleton.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  bool _loading = true;
  bool _saving = false;

  bool _biometricAuth = true;
  bool _twoFactorAuth = false;

  late final TextEditingController _currentPwdCtr;
  late final TextEditingController _newPwdCtr;
  late final TextEditingController _confirmPwdCtr;

  String _newPassword = '';

  @override
  void initState() {
    super.initState();
    _currentPwdCtr = TextEditingController();
    _newPwdCtr = TextEditingController();
    _confirmPwdCtr = TextEditingController();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _currentPwdCtr.dispose();
    _newPwdCtr.dispose();
    _confirmPwdCtr.dispose();
    super.dispose();
  }

  int _strengthScore(String value) {
    var score = 0;
    if (value.length >= 8) score++;
    if (value.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(value) && RegExp(r'[a-z]').hasMatch(value)) score++;
    if (RegExp(r'[0-9]').hasMatch(value)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) score++;
    return score;
  }

  String _strengthLabel(int score) {
    if (score <= 1) return 'Weak';
    if (score <= 3) return 'Fair';
    if (score <= 4) return 'Good';
    return 'Strong';
  }

  Color _strengthColor(int score) {
    if (score <= 1) return AppColors.destructive;
    if (score <= 3) return AppColors.warning;
    if (score <= 4) return AppColors.success;
    return AppColors.primary;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _changePassword() {
    if (_saving) return;
    final current = _currentPwdCtr.text;
    final next = _newPwdCtr.text;
    final confirm = _confirmPwdCtr.text;

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      _showSnack('Please fill in all password fields');
      return;
    }
    if (next == current) {
      _showSnack('New password must be different from current password');
      return;
    }
    if (next != confirm) {
      _showSnack('New passwords do not match');
      return;
    }
    if (_strengthScore(next) < 3) {
      _showSnack('Password is too weak — add uppercase, numbers and symbols');
      return;
    }

    setState(() => _saving = true);
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _saving = false);
      _currentPwdCtr.clear();
      _newPwdCtr.clear();
      _confirmPwdCtr.clear();
      _newPassword = '';
      _showSnack('Password updated successfully');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return _buildLoadingState(isDark: isDark);
    }

    final score = _strengthScore(_newPassword);
    final hasPassword = _newPassword.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Security & Password'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text('Change Password', style: AppTypography.badge(isDark: isDark).copyWith(color: AppColors.primary)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  AppTextField(
                    controller: _currentPwdCtr,
                    label: 'Current Password',
                    hint: 'Enter current password',
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _newPwdCtr,
                    label: 'New Password',
                    hint: 'At least 8 characters',
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20),
                    onChanged: (value) => setState(() => _newPassword = value),
                  ),
                  if (hasPassword) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: score / 5,
                              minHeight: 6,
                              backgroundColor: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                              valueColor: AlwaysStoppedAnimation<Color>(_strengthColor(score)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _strengthLabel(score),
                          style: AppTypography.badge(isDark: isDark).copyWith(color: _strengthColor(score)),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _confirmPwdCtr,
                    label: 'Confirm New Password',
                    hint: 'Re-enter new password',
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    onSubmitted: (_) => _changePassword(),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Update Password',
                    isLoading: _saving,
                    icon: const Icon(Icons.check_rounded, size: 20),
                    onPressed: _changePassword,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Additional Protection', style: AppTypography.badge(isDark: isDark).copyWith(color: AppColors.primary)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _SecurityToggleTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric Login',
                    subtitle: 'Unlock with Face ID / Fingerprint',
                    value: _biometricAuth,
                    isDark: isDark,
                    onChanged: (value) {
                      setState(() => _biometricAuth = value);
                      HapticFeedback.lightImpact();
                      _showSnack(value ? 'Biometric login enabled' : 'Biometric login disabled');
                    },
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0x33FFFFFF),
                  ),
                  _SecurityToggleTile(
                    icon: Icons.shield_outlined,
                    title: 'Two-Factor Authentication',
                    subtitle: 'Extra security on sign in',
                    value: _twoFactorAuth,
                    isDark: isDark,
                    onChanged: (value) {
                      setState(() => _twoFactorAuth = value);
                      HapticFeedback.lightImpact();
                      _showSnack(value ? '2FA enabled' : '2FA disabled');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You can manage security codes and login history under Active Devices.',
              style: AppTypography.small(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState({required bool isDark}) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Security & Password'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: const [
            SkeletonLine(width: 130, height: 14),
            SizedBox(height: 10),
            _SecurityCardSkeleton(lines: 3),
            SizedBox(height: 24),
            SkeletonLine(width: 150, height: 14),
            SizedBox(height: 10),
            _SecurityCardSkeleton(lines: 2),
          ],
        ),
      ),
    );
  }
}

class _SecurityToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _SecurityToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium(isDark: isDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.small(isDark: isDark)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            activeThumbColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SecurityCardSkeleton extends StatelessWidget {
  final int lines;

  const _SecurityCardSkeleton({required this.lines});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: [
          for (int i = 0; i < lines; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            const Row(
              children: [
                SkeletonBox(width: 40, height: 40, radius: 10),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 120),
                      SizedBox(height: 4),
                      SkeletonLine(width: 180),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                SkeletonBox(width: 40, height: 24, radius: 12),
              ],
            ),
          ],
          const SizedBox(height: 8),
          const SkeletonBox(width: double.infinity, height: 52, radius: 16),
        ],
      ),
    );
  }
}
