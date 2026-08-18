import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../router/routes.dart';

const _languages = ['English (US)', 'বাংলা', 'हिन्दी'];

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _language = _languages.first;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _emailNotifications = true;
  bool _twoFactorAuth = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text('Language', style: AppTypography.titleLarge(isDark: isDark)),
              ),
              for (final lang in _languages)
                ListTile(
                  leading: Icon(
                    lang == _language
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: lang == _language ? AppColors.primary : null,
                  ),
                  title: Text(lang, style: AppTypography.titleMedium(isDark: isDark)),
                  onTap: () => Navigator.of(context).pop(lang),
                ),
            ],
          ),
        );
      },
    );
    if (selected == null || selected == _language) return;
    setState(() => _language = selected);
    _showSnack('Language set to $selected');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    if (_loading) {
      return _buildLoadingState();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            const _SectionLabel('Preferences'),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: _language,
                  isDark: isDark,
                  onTap: _pickLanguage,
                ),
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Toggle between light and dark theme',
                  isDark: isDark,
                  trailing: Switch(
                    value: themeMode == ThemeMode.dark,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) => ref.read(themeModeProvider.notifier).state =
                        value ? ThemeMode.dark : ThemeMode.light,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _SectionLabel('Notifications'),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Order status & offers',
                  isDark: isDark,
                  trailing: Switch(
                    value: _pushNotifications,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) => setState(() => _pushNotifications = value),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.sms_outlined,
                  title: 'SMS Notifications',
                  subtitle: 'Delivery updates via SMS',
                  isDark: isDark,
                  trailing: Switch(
                    value: _smsNotifications,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) => setState(() => _smsNotifications = value),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.email_outlined,
                  title: 'Email Notifications',
                  subtitle: 'Receipts & account alerts',
                  isDark: isDark,
                  trailing: Switch(
                    value: _emailNotifications,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) => setState(() => _emailNotifications = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _SectionLabel('Security'),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  isDark: isDark,
                  onTap: () => context.push('${AppRoutes.resetPassword}?target=password'),
                ),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Two-Factor Authentication',
                  subtitle: 'Extra security on sign in',
                  isDark: isDark,
                  trailing: Switch(
                    value: _twoFactorAuth,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) => setState(() => _twoFactorAuth = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _SectionLabel('About'),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms & conditions',
                  isDark: isDark,
                  onTap: () => _showSnack('Terms of Service'),
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'How your data is handled',
                  isDark: isDark,
                  onTap: () => _showSnack('Privacy Policy'),
                ),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  subtitle: 'FONDO v1.0.0',
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: const [
            SkeletonLine(width: 90, height: 14),
            SizedBox(height: 8),
            _SettingsCardSkeleton(),
            SizedBox(height: 20),
            SkeletonLine(width: 110, height: 14),
            SizedBox(height: 8),
            _SettingsCardSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel(this.title);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: AppTypography.badge(isDark: isDark).copyWith(color: AppColors.primary)),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _SettingsCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            );
          }
          return children[index ~/ 2];
        }),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
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
              if (trailing != null)
                trailing!
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCardSkeleton extends StatelessWidget {
  const _SettingsCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SkeletonBox(width: 40, height: 40, radius: 10),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 110),
                        SizedBox(height: 4),
                        SkeletonLine(width: 170),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  SkeletonBox(width: 40, height: 24, radius: 12),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
