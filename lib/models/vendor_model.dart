enum VendorVerificationStatus { pending, approved, rejected }

enum VendorDocumentStatus { pending, approved, rejected, expired }

enum VendorDocumentType { tradeLicense, nid, tin }

class VendorDocument {
  final VendorDocumentType type;
  final String number;
  final VendorDocumentStatus status;
  final DateTime? issuedAt;
  final DateTime? expiry;

  const VendorDocument({
    required this.type,
    required this.number,
    required this.status,
    this.issuedAt,
    this.expiry,
  });

  String get typeLabel {
    switch (type) {
      case VendorDocumentType.tradeLicense:
        return 'Trade License';
      case VendorDocumentType.nid:
        return 'NID';
      case VendorDocumentType.tin:
        return 'TIN';
    }
  }
}

class VendorModel {
  final String id;
  final String businessName;
  final String ownerName;
  final String phone;
  final String email;
  final String logo;
  final String description;
  final String businessType;
  final String category;
  final int foundedYear;
  final int employeeCount;
  final bool isOnline;
  final VendorVerificationStatus verificationStatus;
  final List<VendorDocument> documents;
  final double rating;
  final int totalOrders;

  const VendorModel({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.phone,
    required this.email,
    this.logo = '',
    required this.description,
    required this.businessType,
    required this.category,
    required this.foundedYear,
    required this.employeeCount,
    this.isOnline = true,
    this.verificationStatus = VendorVerificationStatus.pending,
    this.documents = const [],
    this.rating = 0,
    this.totalOrders = 0,
  });
}
