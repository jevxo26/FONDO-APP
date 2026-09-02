/// Customer destination address model for deliveries and location mapping.
class AddressModel {
  /// Unique identifier of the address record.
  final String id;

  /// Semantic label (e.g. "Home", "Office", "Gym").
  final String label;

  /// Road, house/holding number, and area description.
  final String street;

  /// City or metropolitan zone (e.g. "Dhaka", "Chattogram").
  final String city;

  /// Division or state region (e.g. "Dhaka", "Sylhet").
  final String state;

  /// Postal zip code string.
  final String zipCode;

  /// Country name (defaults to "Bangladesh").
  final String country;

  /// Geographical coordinate latitude.
  final double? latitude;

  /// Geographical coordinate longitude.
  final double? longitude;

  /// Indicates whether this is the primary selected delivery address.
  final bool isDefault;

  /// Specialized notes for the courier (e.g., "Gate 2, 4th floor flat B-4").
  final String? deliveryInstructions;

  /// Creates an [AddressModel] instance.
  const AddressModel({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.deliveryInstructions,
  });

  /// Constructs an [AddressModel] deserialized from a backend JSON map.
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      label: json['label']?.toString() ?? 'Home',
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      zipCode: json['zipCode']?.toString() ?? json['postalCode']?.toString() ?? '',
      country: json['country']?.toString() ?? 'Bangladesh',
      latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : null,
      longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : null,
      isDefault: json['isDefault'] == true,
      deliveryInstructions: json['deliveryInstructions']?.toString(),
    );
  }

  /// Creates a modified copy of this [AddressModel].
  AddressModel copyWith({
    String? id,
    String? label,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    double? latitude,
    double? longitude,
    bool? isDefault,
    String? deliveryInstructions,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
    );
  }

  /// Serializes this [AddressModel] to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'deliveryInstructions': deliveryInstructions,
    };
  }
}
