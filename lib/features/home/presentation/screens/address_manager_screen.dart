import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/address_model.dart';
import '../providers/user_location_provider.dart';

class AddressManagerScreen extends ConsumerStatefulWidget {
  const AddressManagerScreen({super.key});

  @override
  ConsumerState<AddressManagerScreen> createState() => _AddressManagerScreenState();
}

class _AddressManagerScreenState extends ConsumerState<AddressManagerScreen> {
  late List<AddressModel> _addresses;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _addresses = List<AddressModel>.from(mockAddresses);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _deleteAddress(String id) {
    final address = _addresses.firstWhere((a) => a.id == id);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete Address'),
        content: Text('Remove "${address.label}" (${address.street}) from your saved addresses?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _addresses.removeWhere((a) => a.id == id));
              if (address.isDefault && _addresses.isNotEmpty) {
                _addresses[0] = _addresses[0].copyWith(isDefault: true);
                ref.read(userLocationProvider.notifier).state =
                    '${_addresses[0].label} • ${_addresses[0].street}';
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed ${address.label} address'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.destructive),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleDefault(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      for (var i = 0; i < _addresses.length; i++) {
        final isMatch = _addresses[i].id == id;
        _addresses[i] = _addresses[i].copyWith(isDefault: isMatch);
        if (isMatch) {
          ref.read(userLocationProvider.notifier).state =
              '${_addresses[i].label} • ${_addresses[i].street}';
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default delivery address updated!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddressModal({AddressModel? editTarget}) {
    HapticFeedback.mediumImpact();
    final isEdit = editTarget != null;
    String selectedLabel = editTarget?.label ?? 'Home';
    final streetCtr = TextEditingController(text: editTarget?.street ?? '');
    final instructionsCtr = TextEditingController(text: editTarget?.deliveryInstructions ?? '');
    String selectedDivision = 'Dhaka';
    String selectedArea = editTarget?.city ?? 'Dhanmondi, Dhaka';
    bool isDefault = editTarget?.isDefault ?? (_addresses.isEmpty);

    final divisions = ['Dhaka', 'Chittagong', 'Sylhet', 'Rajshahi', 'Khulna'];
    final areas = [
      'Dhanmondi, Dhaka',
      'Gulshan 1, Dhaka',
      'Gulshan 2, Dhaka',
      'Banani, Dhaka',
      'Uttara Sector 3, Dhaka',
      'Uttara Sector 7, Dhaka',
      'Mirpur 10, Dhaka',
      'Mohammadpur, Dhaka',
      'Badda, Dhaka',
      'Bashundhara R/A, Dhaka',
      'Agrabad, Chittagong',
      'Nasirabad, Chittagong',
      'Zindabazar, Sylhet',
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          final isDark = Theme.of(sheetCtx).brightness == Brightness.dark;
          return Container(
            padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(sheetCtx).viewInsets.bottom + 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        isEdit ? 'Edit Address' : 'Add Delivery Address',
                        style: AppTypography.titleLarge(isDark: isDark),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Label selector chips
                  Text('Address Label', style: AppTypography.label(isDark: isDark)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: [
                      ('Home', Icons.home_rounded),
                      ('Work', Icons.work_rounded),
                      ('Partner', Icons.favorite_rounded),
                      ('Other', Icons.location_on_rounded),
                    ].map((entry) {
                      final (name, icon) = entry;
                      final selected = selectedLabel == name;
                      return ChoiceChip(
                        avatar: Icon(icon, size: 16, color: selected ? AppColors.primaryForeground : null),
                        label: Text(name),
                        selected: selected,
                        selectedColor: AppColors.primary,
                        backgroundColor: isDark ? AppColors.cardDark : AppColors.mutedLight,
                        labelStyle: TextStyle(color: selected ? AppColors.primaryForeground : null, fontWeight: FontWeight.w600),
                        onSelected: (_) {
                          HapticFeedback.selectionClick();
                          setSheetState(() => selectedLabel = name);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Street & House details
                  TextField(
                    controller: streetCtr,
                    decoration: InputDecoration(
                      labelText: 'Street, House & Flat No.',
                      hintText: 'e.g. House 42, Road 9/A, Apt 4B',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.apartment_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Division Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: selectedDivision,
                    decoration: InputDecoration(
                      labelText: 'Division',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.map_rounded, size: 20),
                    ),
                    items: divisions.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (val) {
                      if (val != null) setSheetState(() => selectedDivision = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  // Area / Thana Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: areas.contains(selectedArea) ? selectedArea : areas.first,
                    decoration: InputDecoration(
                      labelText: 'Area / District',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.location_city_rounded, size: 20),
                    ),
                    items: areas.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                    onChanged: (val) {
                      if (val != null) setSheetState(() => selectedArea = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  // Delivery Instructions to Rider
                  TextField(
                    controller: instructionsCtr,
                    decoration: InputDecoration(
                      labelText: 'Note for Rider (Optional)',
                      hintText: 'e.g. Call upon arrival, leave with concierge',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.directions_bike_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Set as default toggle
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Set as Default Address', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Used automatically at checkout', style: TextStyle(fontSize: 12)),
                    value: isDefault,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setSheetState(() => isDefault = val),
                  ),
                  const SizedBox(height: 16),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (streetCtr.text.trim().isEmpty) {
                          ScaffoldMessenger.of(sheetCtx).showSnackBar(
                            const SnackBar(content: Text('Please enter street and house details')),
                          );
                          return;
                        }

                        HapticFeedback.heavyImpact();
                        Navigator.of(sheetCtx).pop();

                        final newAddress = AddressModel(
                          id: isEdit ? editTarget.id : 'addr_${DateTime.now().millisecondsSinceEpoch}',
                          label: selectedLabel,
                          street: streetCtr.text.trim(),
                          city: selectedArea,
                          state: selectedDivision,
                          zipCode: '1209',
                          country: 'Bangladesh',
                          latitude: 23.7500,
                          longitude: 90.3700,
                          isDefault: isDefault,
                          deliveryInstructions: instructionsCtr.text.trim().isNotEmpty ? instructionsCtr.text.trim() : null,
                        );

                        setState(() {
                          if (isDefault) {
                            for (var i = 0; i < _addresses.length; i++) {
                              _addresses[i] = _addresses[i].copyWith(isDefault: false);
                            }
                            ref.read(userLocationProvider.notifier).state =
                                '${newAddress.label} • ${newAddress.street}';
                          }

                          if (isEdit) {
                            final idx = _addresses.indexWhere((a) => a.id == editTarget.id);
                            if (idx != -1) _addresses[idx] = newAddress;
                          } else {
                            _addresses.insert(0, newAddress);
                          }
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isEdit ? 'Address updated!' : 'New address saved!'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.primaryForeground,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        isEdit ? 'Update Address' : 'Save Address',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return _buildLoadingState();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Saved Addresses'),
      ),
      body: Stack(
        children: [
          const GlowOrbs(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_addresses.length} saved location${_addresses.length == 1 ? '' : 's'}',
                        style: AppTypography.bodyMedium(isDark: isDark).copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Tap address to set default',
                        style: AppTypography.small(isDark: isDark),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _addresses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_off_outlined, size: 40, color: AppColors.primary),
                              ),
                              const SizedBox(height: 16),
                              Text('No saved addresses yet', style: AppTypography.titleLarge(isDark: isDark)),
                              const SizedBox(height: 6),
                              Text('Add your home or office address for fast checkout.', style: AppTypography.bodyMedium(isDark: isDark)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          itemCount: _addresses.length,
                          itemBuilder: (context, index) {
                            final addr = _addresses[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _AddressCard(
                                address: addr,
                                isDark: isDark,
                                onEdit: () => _showAddressModal(editTarget: addr),
                                onDelete: () => _deleteAddress(addr.id),
                                onSetDefault: () => _toggleDefault(addr.id),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: FilledButton.icon(
                    onPressed: () => _showAddressModal(),
                    icon: const Icon(Icons.add_location_alt_rounded, size: 20),
                    label: const Text('Add New Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.primaryForeground,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Saved Addresses'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: SkeletonLine(width: 140, height: 14),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  SkeletonBox(width: double.infinity, height: 110, radius: 18),
                  SizedBox(height: 12),
                  SkeletonBox(width: double.infinity, height: 110, radius: 18),
                  SizedBox(height: 12),
                  SkeletonBox(width: double.infinity, height: 110, radius: 18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SkeletonBox(width: double.infinity, height: 52, radius: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  IconData _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'partner':
        return Icons.favorite_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIconForLabel(address.label);
    return PressScale(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        radius: 18,
        onTap: onSetDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (address.isDefault ? AppColors.primary : Colors.grey).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: address.isDefault ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  address.label,
                  style: AppTypography.titleMedium(isDark: isDark).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (address.isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'DEFAULT',
                      style: TextStyle(
                        color: AppColors.primaryForeground,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onEdit,
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.destructive),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              address.street,
              style: AppTypography.bodyMedium(isDark: isDark).copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              '${address.city}, ${address.state}',
              style: AppTypography.small(isDark: isDark).copyWith(
                color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
              ),
            ),
            if (address.deliveryInstructions != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 13, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Rider note: ${address.deliveryInstructions}',
                        style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
