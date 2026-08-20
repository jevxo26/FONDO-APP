import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';

const _dietaryOptions = [
  'Vegetarian',
  'Vegan',
  'Halal',
  'Keto',
  'Gluten-Free',
  'Dairy-Free',
  'High Protein',
  'Low Carb',
];

const _healthGoalOptions = [
  'Weight Loss',
  'Muscle Gain',
  'Balanced Diet',
  'Heart Health',
  'Energy Boost',
];

const _avatarOptions = [
  '🧑‍🍳',
  '👨‍🍳',
  '👩‍🍳',
  '🥗',
  '🍛',
  '🍜',
  '🍣',
  '🧁',
];

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool _loading = true;
  bool _saving = false;

  late final TextEditingController _firstNameCtr;
  late final TextEditingController _lastNameCtr;
  late final TextEditingController _emailCtr;
  late final TextEditingController _phoneCtr;

  String _avatar = '';
  String? _gender;
  String? _dob;
  final Set<String> _dietary = <String>{};
  String? _healthGoal;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    final nameParts = user.name.split(' ');
    _firstNameCtr = TextEditingController(text: nameParts.first);
    _lastNameCtr = TextEditingController(text: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');
    _emailCtr = TextEditingController(text: user.email);
    _phoneCtr = TextEditingController(text: user.phone);
    _avatar = user.avatar ?? _avatarOptions.first;
    _gender = user.gender;
    _dob = user.dob;
    _dietary.addAll(user.dietaryPreferences);
    _healthGoal = user.healthGoals.isNotEmpty ? user.healthGoals.first : null;

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _firstNameCtr.dispose();
    _lastNameCtr.dispose();
    _emailCtr.dispose();
    _phoneCtr.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    HapticFeedback.lightImpact();
    final selected = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose an Avatar', style: AppTypography.titleLarge(isDark: isDark)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final option in _avatarOptions)
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(option),
                        child: Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: option == _avatar
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : isDark ? AppColors.cardDark : AppColors.cardLight,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: option == _avatar
                                  ? AppColors.primary
                                  : isDark ? AppColors.borderDark : AppColors.borderLight,
                              width: option == _avatar ? 2 : 1,
                            ),
                          ),
                          child: Text(option, style: const TextStyle(fontSize: 26)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null) setState(() => _avatar = selected);
  }

  Future<void> _pickDob() async {
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    final initial = _dob != null ? DateTime.tryParse(_dob!) : DateTime(now.year - 25);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 80),
      lastDate: now,
      helpText: 'Date of Birth',
    );
    if (picked != null) {
      final formatted =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() => _dob = formatted);
    }
  }

  void _toggleDietary(String tag) {
    setState(() {
      if (_dietary.contains(tag)) {
        _dietary.remove(tag);
      } else {
        _dietary.add(tag);
      }
    });
  }

  void _save() {
    if (_saving) return;
    final firstName = _firstNameCtr.text.trim();
    final lastName = _lastNameCtr.text.trim();
    if (firstName.isEmpty || _emailCtr.text.trim().isEmpty || _phoneCtr.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in your name, email and phone'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _saving = true);
    HapticFeedback.lightImpact();
    final current = ref.read(currentUserProvider);
    final updated = current.copyWith(
      name: lastName.isEmpty ? firstName : '$firstName $lastName',
      email: _emailCtr.text.trim(),
      phone: _phoneCtr.text.trim(),
      avatar: _avatar,
      gender: _gender,
      dob: _dob,
      dietaryPreferences: _dietary.toList()..sort(),
      healthGoals: _healthGoal == null ? const [] : [_healthGoal!],
    );
    ref.read(authControllerProvider.notifier).updateUser(updated);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return _buildLoadingState(isDark: isDark);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit Profile'),
      ),
      body: Stack(
        children: [
          const GlowOrbs(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Column(
                  children: [
                    Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                        child: Text(_avatar, style: const TextStyle(fontSize: 40)),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_rounded, size: 16, color: AppColors.primaryForeground),
                      ),
                    ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to change avatar',
                      style: AppTypography.small(isDark: isDark).copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _firstNameCtr,
                    label: 'First Name',
                    hint: 'Raihan',
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: _lastNameCtr,
                    label: 'Last Name',
                    hint: 'Ahmed',
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _emailCtr,
              label: 'Email Address',
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _phoneCtr,
              label: 'Phone Number',
              hint: '+8801XXXXXXXXX',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(Icons.phone_outlined, size: 20),
            ),
            const SizedBox(height: 20),
            Text('Gender', style: AppTypography.labelConvention(isDark: isDark)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final g in const ['Male', 'Female', 'Other'])
                  ChoiceChip(
                    label: Text(g),
                    selected: _gender == g,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    labelStyle: AppTypography.titleMedium(isDark: isDark).copyWith(
                      color: _gender == g ? AppColors.primary : null,
                    ),
                    side: BorderSide(
                      color: _gender == g
                          ? AppColors.primary
                          : isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() => _gender = g);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Date of Birth', style: AppTypography.labelConvention(isDark: isDark)),
            const SizedBox(height: 8),
            PressScale(
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                radius: 14,
                onTap: _pickDob,
                child: Row(
                    children: [
                      Icon(
                        Icons.cake_outlined,
                        size: 20,
                        color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _dob ?? 'Select your date of birth',
                          style: AppTypography.bodyLarge(isDark: isDark).copyWith(
                            color: _dob == null ? AppColors.mutedForegroundLight : null,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text('Dietary Preferences', style: AppTypography.labelConvention(isDark: isDark)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in _dietaryOptions)
                  FilterChip(
                    label: Text(tag),
                    selected: _dietary.contains(tag),
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    labelStyle: AppTypography.titleMedium(isDark: isDark).copyWith(
                      color: _dietary.contains(tag) ? AppColors.primary : null,
                    ),
                    side: BorderSide(
                      color: _dietary.contains(tag)
                          ? AppColors.primary
                          : isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      _toggleDietary(tag);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Health Goal', style: AppTypography.labelConvention(isDark: isDark)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final goal in _healthGoalOptions)
                  ChoiceChip(
                    label: Text(goal),
                    selected: _healthGoal == goal,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    labelStyle: AppTypography.titleMedium(isDark: isDark).copyWith(
                      color: _healthGoal == goal ? AppColors.primary : null,
                    ),
                    side: BorderSide(
                      color: _healthGoal == goal
                          ? AppColors.primary
                          : isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() => _healthGoal = goal);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Save Changes',
              isLoading: _saving,
              icon: const Icon(Icons.check_rounded, size: 20),
              onPressed: _save,
            ),
            ],
          ),
        ),
      ],
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
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            const Center(child: SkeletonBox(width: 88, height: 88, radius: 44)),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(child: SkeletonLine(width: 100, height: 16)),
                SizedBox(width: 12),
                Expanded(child: SkeletonLine(width: 100, height: 16)),
              ],
            ),
            const SizedBox(height: 16),
            const SkeletonLine(width: 160, height: 16),
            const SizedBox(height: 16),
            const SkeletonLine(width: 120, height: 16),
            const SizedBox(height: 20),
            const SkeletonBox(width: double.infinity, height: 40, radius: 12),
            const SizedBox(height: 20),
            const SkeletonBox(width: double.infinity, height: 48, radius: 14),
            const SizedBox(height: 24),
            const SkeletonBox(width: double.infinity, height: 40, radius: 12),
            const SizedBox(height: 32),
            SkeletonBox(
              width: double.infinity,
              height: 52,
              radius: 16,
            ),
          ],
        ),
      ),
    );
  }
}
