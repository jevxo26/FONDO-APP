import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../models/address_model.dart';
import '../controllers/auth_controller.dart';

class AddDeliveryAddressScreen extends ConsumerStatefulWidget {
  const AddDeliveryAddressScreen({super.key});

  @override
  ConsumerState<AddDeliveryAddressScreen> createState() => _AddDeliveryAddressScreenState();
}

class _AddDeliveryAddressScreenState extends ConsumerState<AddDeliveryAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController(text: 'Dhaka');
  final _stateController = TextEditingController(text: 'Dhaka Division');
  final _zipCodeController = TextEditingController(text: '1212');
  final _instructionsController = TextEditingController();
  String _selectedLabel = 'Home';
  bool _isDefault = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final address = AddressModel(
      id: '',
      label: _selectedLabel,
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _zipCodeController.text.trim(),
      country: 'Bangladesh',
      isDefault: _isDefault,
      deliveryInstructions: _instructionsController.text.trim().isEmpty ? null : _instructionsController.text.trim(),
    );

    final success = await ref.read(authControllerProvider.notifier).addAddress(address);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save delivery address'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Widget _buildLabelChip(String label, bool isDark) {
    final isSelected = _selectedLabel == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLabel = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.inputFillDark : AppColors.inputFillLight),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium(isDark: isDark).copyWith(
            color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Delivery Address'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where should we deliver? 📍',
                  style: AppTypography.displayHeadline(isDark: isDark),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please provide your primary delivery location to explore nearby restaurants and meals.',
                  style: AppTypography.bodyMedium(isDark: isDark),
                ),
                const SizedBox(height: 24),
                Text(
                  'Address Label',
                  style: AppTypography.bodyMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildLabelChip('Home', isDark),
                    const SizedBox(width: 12),
                    _buildLabelChip('Work', isDark),
                    const SizedBox(width: 12),
                    _buildLabelChip('Other', isDark),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _streetController,
                  label: 'Street / House / Apartment',
                  hint: 'House 42, Road 11, Block D, Banani',
                  prefixIcon: const Icon(Icons.location_on_outline),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your street address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _cityController,
                        label: 'City / Area',
                        hint: 'Dhaka',
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
                      child: CustomTextField(
                        controller: _zipCodeController,
                        label: 'Postal Code',
                        hint: '1212',
                        keyboardType: TextInputType.number,
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
                CustomTextField(
                  controller: _instructionsController,
                  label: 'Delivery Instructions (Optional)',
                  hint: 'Leave at front desk / Call upon arrival',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Switch.adaptive(
                      value: _isDefault,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {
                          _isDefault = val;
                        });
                      },
                    ),
                    Text(
                      'Set as default delivery address',
                      style: AppTypography.bodyMedium(isDark: isDark),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  text: 'Save Address & Start Ordering',
                  isLoading: _isLoading,
                  onPressed: _handleSaveAddress,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
