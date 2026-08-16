import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/vendor_model.dart';

final _mockVendor = VendorModel(
  id: 'ven_001',
  businessName: 'Rafiq Restaurant & Catering',
  ownerName: 'Rafiq Uddin Ahmed',
  phone: '+8801712345678',
  email: 'rafiq@rafiqrestaurant.com',
  description: 'Authentic Bengali cuisine since 1998. Family recipes, farm-fresh ingredients, and same-day delivery across Dhaka.',
  businessType: 'Restaurant & Catering',
  category: 'Bengali Cuisine',
  foundedYear: 1998,
  employeeCount: 42,
  rating: 4.7,
  totalOrders: 18420,
  verificationStatus: VendorVerificationStatus.approved,
  documents: [
    VendorDocument(type: VendorDocumentType.tradeLicense, number: 'TL-DCC-2018-45213', status: VendorDocumentStatus.approved, issuedAt: DateTime(2018, 3, 12), expiry: DateTime(2026, 3, 12)),
    VendorDocument(type: VendorDocumentType.nid, number: '1990123456789', status: VendorDocumentStatus.approved, issuedAt: DateTime(2020, 5, 4)),
    VendorDocument(type: VendorDocumentType.tin, number: '202345671', status: VendorDocumentStatus.pending, issuedAt: DateTime(2026, 6, 20)),
  ],
);

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final VendorModel _vendor = _mockVendor;
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = _vendor.verificationStatus;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Vendor Profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        child: Text(
                          'RR',
                          style: AppTypography.titleLarge(isDark: false).copyWith(
                            color: AppColors.primaryForeground,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _vendor.businessName,
                              style: AppTypography.titleLarge(isDark: false).copyWith(
                                color: AppColors.primaryForeground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Owner: ${_vendor.ownerName}',
                              style: AppTypography.small(isDark: false).copyWith(
                                color: AppColors.primaryForeground.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _verificationColor(status).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_verificationIcon(status), size: 14, color: _verificationColor(status)),
                        const SizedBox(width: 6),
                        Text(
                          _verificationLabel(status),
                          style: AppTypography.badge(isDark: false).copyWith(
                            color: _verificationColor(status),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Accepting Orders', style: AppTypography.label(isDark: isDark)),
                        const SizedBox(height: 2),
                        Text('Control your online availability', style: AppTypography.small(isDark: isDark)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isOnline,
                    activeThumbColor: AppColors.primary,
                    onChanged: (v) => setState(() => _isOnline = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Business Details', style: AppTypography.label(isDark: isDark)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Business Type', value: _vendor.businessType, isDark: isDark),
                  _DetailRow(label: 'Category', value: _vendor.category, isDark: isDark),
                  _DetailRow(label: 'Founded', value: '${_vendor.foundedYear}', isDark: isDark),
                  _DetailRow(label: 'Employees', value: '${_vendor.employeeCount}', isDark: isDark),
                  _DetailRow(label: 'Phone', value: _vendor.phone, isDark: isDark),
                  _DetailRow(label: 'Email', value: _vendor.email, isDark: isDark),
                  _DetailRow(
                    label: 'Rating',
                    value: _vendor.rating.toStringAsFixed(1),
                    icon: Icons.star_rounded,
                    iconColor: AppColors.warning,
                    isDark: isDark,
                  ),
                  _DetailRow(
                    label: 'Total Orders',
                    value: _formatNumber(_vendor.totalOrders),
                    isDark: isDark,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('About', style: AppTypography.label(isDark: isDark)),
            const SizedBox(height: 8),
            Text(_vendor.description, style: AppTypography.bodyMedium(isDark: isDark)),
            const SizedBox(height: 28),
            Text('Documents & Verification', style: AppTypography.label(isDark: isDark)),
            const SizedBox(height: 12),
            ..._vendor.documents.map((doc) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DocumentCard(document: doc, isDark: isDark),
            )),
            if (_vendor.documents.any((d) => d.status == VendorDocumentStatus.pending))
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'TIN verification is pending. Approvals usually complete within 24 hours.',
                        style: AppTypography.small(isDark: isDark),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text('Log Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.destructive,
                side: const BorderSide(color: AppColors.destructive),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool showDivider;
  final IconData? icon;
  final Color? iconColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.showDivider = true,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              SizedBox(
                width: 104,
                child: Text(
                  label,
                  style: AppTypography.small(isDark: isDark),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 14, color: iconColor),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: AppTypography.bodyMedium(isDark: isDark),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final VendorDocument document;
  final bool isDark;

  const _DocumentCard({required this.document, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final statusColor = _documentColor(document.status);
    final expiry = document.expiry;
    final expired = expiry != null && expiry.isBefore(DateTime(2026, 7, 31));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_documentIcon(document.type), color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.typeLabel,
                  style: AppTypography.bodyMedium(isDark: isDark).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(document.number, style: AppTypography.small(isDark: isDark)),
                if (expiry != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    expired ? 'Expired ${_formatDate(expiry)}' : 'Expires ${_formatDate(expiry)}',
                    style: AppTypography.small(isDark: isDark).copyWith(
                      color: expired ? AppColors.destructive : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          _DocumentPill(status: document.status),
        ],
      ),
    );
  }
}

class _DocumentPill extends StatelessWidget {
  final VendorDocumentStatus status;

  const _DocumentPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _documentColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _documentLabel(status),
        style: AppTypography.badge(isDark: false).copyWith(color: color, fontSize: 9),
      ),
    );
  }
}

IconData _verificationIcon(VendorVerificationStatus status) {
  switch (status) {
    case VendorVerificationStatus.approved:
      return Icons.verified_rounded;
    case VendorVerificationStatus.pending:
      return Icons.hourglass_top_rounded;
    case VendorVerificationStatus.rejected:
      return Icons.cancel_rounded;
  }
}

IconData _documentIcon(VendorDocumentType type) {
  switch (type) {
    case VendorDocumentType.tradeLicense:
      return Icons.badge_rounded;
    case VendorDocumentType.nid:
      return Icons.credit_card_rounded;
    case VendorDocumentType.tin:
      return Icons.receipt_rounded;
  }
}

String _verificationLabel(VendorVerificationStatus status) {
  switch (status) {
    case VendorVerificationStatus.approved:
      return 'VERIFIED';
    case VendorVerificationStatus.pending:
      return 'PENDING VERIFICATION';
    case VendorVerificationStatus.rejected:
      return 'REJECTED';
  }
}

Color _verificationColor(VendorVerificationStatus status) {
  switch (status) {
    case VendorVerificationStatus.approved:
      return AppColors.success;
    case VendorVerificationStatus.pending:
      return AppColors.warning;
    case VendorVerificationStatus.rejected:
      return AppColors.destructive;
  }
}

String _documentLabel(VendorDocumentStatus status) {
  switch (status) {
    case VendorDocumentStatus.approved:
      return 'APPROVED';
    case VendorDocumentStatus.pending:
      return 'PENDING';
    case VendorDocumentStatus.rejected:
      return 'REJECTED';
    case VendorDocumentStatus.expired:
      return 'EXPIRED';
  }
}

Color _documentColor(VendorDocumentStatus status) {
  switch (status) {
    case VendorDocumentStatus.approved:
      return AppColors.success;
    case VendorDocumentStatus.pending:
      return AppColors.warning;
    case VendorDocumentStatus.rejected:
      return AppColors.destructive;
    case VendorDocumentStatus.expired:
      return AppColors.mutedForegroundLight;
  }
}

String _formatDate(DateTime dt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

String _formatNumber(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}
