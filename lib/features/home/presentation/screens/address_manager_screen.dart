import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/address_model.dart';

class AddressManagerScreen extends StatefulWidget {
  const AddressManagerScreen({super.key});

  @override
  State<AddressManagerScreen> createState() => _AddressManagerScreenState();
}

class _AddressManagerScreenState extends State<AddressManagerScreen> {
  late List<AddressModel> _addresses;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _addresses = mockAddresses;
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _deleteAddress(String id) {
    final address = _addresses.firstWhere((a) => a.id == id);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Remove "${address.label}" address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _addresses.removeWhere((a) => a.id == id));
              if (address.isDefault && _addresses.isNotEmpty) {
                _addresses[0] = AddressModel(
                  id: _addresses[0].id,
                  label: _addresses[0].label,
                  street: _addresses[0].street,
                  city: _addresses[0].city,
                  state: _addresses[0].state,
                  zipCode: _addresses[0].zipCode,
                  country: _addresses[0].country,
                  latitude: _addresses[0].latitude,
                  longitude: _addresses[0].longitude,
                  isDefault: true,
                  deliveryInstructions: _addresses[0].deliveryInstructions,
                );
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.destructive)),
          ),
        ],
      ),
    );
  }

  void _toggleDefault(String id) {
    setState(() {
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i] = AddressModel(
          id: _addresses[i].id,
          label: _addresses[i].label,
          street: _addresses[i].street,
          city: _addresses[i].city,
          state: _addresses[i].state,
          zipCode: _addresses[i].zipCode,
          country: _addresses[i].country,
          latitude: _addresses[i].latitude,
          longitude: _addresses[i].longitude,
          isDefault: _addresses[i].id == id,
          deliveryInstructions: _addresses[i].deliveryInstructions,
        );
      }
    });
  }

  void _editAddress(AddressModel address) {
    final labelCtr = TextEditingController(text: address.label);
    final streetCtr = TextEditingController(text: address.street);
    final cityCtr = TextEditingController(text: address.city);
    final instructionsCtr = TextEditingController(text: address.deliveryInstructions ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        bool loading = false;
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Address', style: AppTypography.titleLarge(isDark: Theme.of(ctx).brightness == Brightness.dark)),
                const SizedBox(height: 16),
                TextField(
                  controller: labelCtr,
                  decoration: const InputDecoration(labelText: 'Label', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: streetCtr,
                  decoration: const InputDecoration(labelText: 'Street', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cityCtr,
                  decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: instructionsCtr,
                  decoration: const InputDecoration(labelText: 'Delivery Instructions', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    setSheetState(() => loading = true);
                    setState(() {
                      for (var i = 0; i < _addresses.length; i++) {
                        if (_addresses[i].id == address.id) {
                          _addresses[i] = AddressModel(
                            id: _addresses[i].id,
                            label: labelCtr.text,
                            street: streetCtr.text,
                            city: cityCtr.text,
                            state: _addresses[i].state,
                            zipCode: _addresses[i].zipCode,
                            country: _addresses[i].country,
                            latitude: _addresses[i].latitude,
                            longitude: _addresses[i].longitude,
                            isDefault: _addresses[i].isDefault,
                            deliveryInstructions: instructionsCtr.text.isNotEmpty ? instructionsCtr.text : null,
                          );
                        }
                      }
                    });
                    Navigator.of(ctx).pop();
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryForeground,
                  ),
                  child: Text(loading ? 'Saving…' : 'Save'),
                ),
              ],
            ),
          ),
        );
      },
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
        title: Text('Saved Addresses'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Text(
              '${_addresses.length} address${_addresses.length == 1 ? '' : 'es'} on file',
              style: AppTypography.bodyMedium(isDark: isDark),
            ),
          ),
          Expanded(
            child: _addresses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_off_outlined, size: 48, color: AppColors.primary.withValues(alpha: 0.3)),
                        const SizedBox(height: 12),
                        Text('No addresses saved', style: AppTypography.bodyMedium(isDark: isDark)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      final addr = _addresses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _AddressCard(
                          address: addr,
                          isDark: isDark,
                          onEdit: () => _editAddress(addr),
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
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add New Address'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
              ),
            ),
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Saved Addresses'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: SkeletonLine(width: 150),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  _AddressCardSkeleton(),
                  SizedBox(height: 12),
                  _AddressCardSkeleton(),
                  SizedBox(height: 12),
                  _AddressCardSkeleton(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SkeletonBox(width: double.infinity, height: 48, radius: 12),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: address.isDefault ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 18, color: address.isDefault ? AppColors.primary : (isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight)),
              const SizedBox(width: 8),
              Text(address.label, style: AppTypography.label(isDark: isDark)),
              if (address.isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Default',
                    style: AppTypography.badge(isDark: false).copyWith(color: AppColors.primary, fontSize: 10),
                  ),
                ),
              ],
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight),
                onSelected: (value) {
                  switch (value) {
                    case 'edit': onEdit();
                    case 'delete': onDelete();
                    case 'default': onSetDefault();
                  }
                },
                itemBuilder: (_) => [
                  if (!address.isDefault)
                    const PopupMenuItem(value: 'default', child: Text('Set as Default')),
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: AppColors.destructive))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(address.street, style: AppTypography.bodyMedium(isDark: isDark)),
          const SizedBox(height: 2),
          Text('${address.city}, ${address.state}', style: AppTypography.small(isDark: isDark)),
          if (address.deliveryInstructions != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 14, color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight),
                const SizedBox(width: 4),
                Text('${address.deliveryInstructions}', style: AppTypography.small(isDark: isDark)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AddressCardSkeleton extends StatelessWidget {
  const _AddressCardSkeleton();

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SkeletonBox(width: 18, height: 18, radius: 6),
                  const SizedBox(width: 8),
                  SkeletonLine(width: 80),
                  const SizedBox(width: 8),
                  const SkeletonBox(width: 46, height: 18, radius: 6),
                  const Spacer(),
                  const SkeletonBox(width: 18, height: 18, radius: 6),
                ],
              ),
              const SizedBox(height: 10),
              SkeletonLine(width: w * 0.7),
              const SizedBox(height: 6),
              SkeletonLine(width: w * 0.5),
              const SizedBox(height: 6),
              SkeletonLine(width: w * 0.6),
            ],
          );
        },
      ),
    );
  }
}
