import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/text_link_button.dart';

/// Add Delivery Address screen — §2.6. Static UI — always saves successfully.
class AddDeliveryAddressScreen extends StatefulWidget {
  const AddDeliveryAddressScreen({super.key});

  @override
  State<AddDeliveryAddressScreen> createState() =>
      _AddDeliveryAddressScreenState();
}

class _AddDeliveryAddressScreenState extends State<AddDeliveryAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();
  final _divisionController = TextEditingController();
  final _districtController = TextEditingController();
  final _areaController = TextEditingController();
  final _roadHouseController = TextEditingController();
  final _detailController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _selectedLabel = 'Home';
  bool _showDetails = false;
  String? _fieldError;
  bool _isLoading = false;

  @override
  void dispose() {
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _divisionController.dispose();
    _districtController.dispose();
    _areaController.dispose();
    _roadHouseController.dispose();
    _detailController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _handleSaveAddress() {
    setState(() => _fieldError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      context.go('/home');
    });
  }

  Widget _buildLabelChip(String label, bool isDark) {
    final isSelected = _selectedLabel == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedLabel = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: AppRadii.full,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium(isDark: isDark).copyWith(
            color: isSelected
                ? AppColors.primaryForeground
                : (isDark
                    ? AppColors.foregroundDark
                    : AppColors.foregroundLight),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthScaffold(
      showBackButton: false,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Headline — Fraunces 32/700
            Text(
              'Where should we deliver?',
              style: AppTypography.headlineLarge(isDark: isDark),
            ),

            const SizedBox(height: 8),

            // Subtext — Inter 14, muted
            Text(
              'Please provide your primary delivery location to explore nearby meals.',
              style: AppTypography.bodyMedium(isDark: isDark),
            ),

            const SizedBox(height: 16),

            InlineErrorBanner(
              message: _fieldError,
              onDismiss: () => setState(() => _fieldError = null),
            ),

            const SizedBox(height: 12),

            // Address Label — §2.6: "label (Home/Office/Other pills)"
            Text(
              'Address Label',
              style: AppTypography.labelConvention(isDark: isDark),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildLabelChip('Home', isDark),
                const SizedBox(width: 10),
                _buildLabelChip('Office', isDark),
                const SizedBox(width: 10),
                _buildLabelChip('Other', isDark),
              ],
            ),

            const SizedBox(height: 24),

            // Receiver Name — §2.6
            AppTextField(
              controller: _receiverNameController,
              label: 'Receiver Name',
              hint: 'Who are we delivering to?',
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: isDark
                    ? AppColors.mutedForegroundDark
                    : AppColors.mutedForegroundLight,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Enter receiver name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Receiver Phone — §2.6
            AppTextField(
              controller: _receiverPhoneController,
              label: 'Receiver Phone',
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
                  return 'Enter receiver phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Division — §2.6
            AppTextField(
              controller: _divisionController,
              label: 'Division',
              hint: 'e.g. Dhaka Division',
              prefixIcon: Icon(
                Icons.map_outlined,
                size: 20,
                color: isDark
                    ? AppColors.mutedForegroundDark
                    : AppColors.mutedForegroundLight,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Enter division';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _districtController,
              label: 'District / Area',
              hint: 'e.g. Banani, Dhaka',
              prefixIcon: Icon(
                Icons.location_city_outlined,
                size: 20,
                color: isDark
                    ? AppColors.mutedForegroundDark
                    : AppColors.mutedForegroundLight,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Enter district or area';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Road / House / Apartment — §2.6
            AppTextField(
              controller: _roadHouseController,
              label: 'Road / House / Apartment',
              hint: 'House 42, Road 11, Block D',
              prefixIcon: Icon(
                Icons.home_outlined,
                size: 20,
                color: isDark
                    ? AppColors.mutedForegroundDark
                    : AppColors.mutedForegroundLight,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Enter road/house address';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // "Add more detail" expander — §2.6
            GestureDetector(
              onTap: () => setState(() => _showDetails = !_showDetails),
              child: Row(
                children: [
                  Icon(
                    _showDetails
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Add more detail',
                    style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Collapsible detail fields
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: AppTextField(
                  controller: _detailController,
                  label: 'Apartment / Floor / Unit (Optional)',
                  hint: 'Apt 5B, Floor 5',
                  prefixIcon: Icon(
                    Icons.door_front_door_outlined,
                    size: 20,
                    color: isDark
                        ? AppColors.mutedForegroundDark
                        : AppColors.mutedForegroundLight,
                  ),
                ),
              ),
              crossFadeState: _showDetails
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),

            const SizedBox(height: 16),

            // Delivery Instructions
            AppTextField(
              controller: _instructionsController,
              label: 'Delivery Instructions (Optional)',
              hint: 'Leave at front desk / Call upon arrival',
              maxLines: 2,
            ),

            const SizedBox(height: 28),

            // Primary CTA — §2.6: "Save address"
            PrimaryButton(
              text: 'Save address',
              isLoading: _isLoading,
              onPressed: _handleSaveAddress,
            ),

            const SizedBox(height: 16),

            // Demo data quick-fill
            Center(
              child: GestureDetector(
                onTap: () => setState(() {
                  _selectedLabel = 'Home';
                  _receiverNameController.text = mockReceiverName;
                  _receiverPhoneController.text = mockReceiverPhone;
                  _divisionController.text = mockDivision;
                  _districtController.text = mockDistrict;
                  _roadHouseController.text = mockRoadHouse;
                  _detailController.text = mockAddressDetail;
                  _instructionsController.text = mockDeliveryInstructions;
                  _showDetails = true;
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

            const SizedBox(height: 16),

            // Skip link — §2.6: "Add this later"
            Center(
              child: TextLinkButton(
                text: 'Add this later',
                onPressed: () => context.go('/home'),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
