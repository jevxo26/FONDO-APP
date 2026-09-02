/// Core authenticated customer or staff identity profile in FONDO.
class UserModel {
  /// Unique database user identifier.
  final String id;

  /// Full customer name.
  final String name;

  /// Email address used for authentication and receipts.
  final String email;

  /// Mobile phone number used for SMS verification and rider delivery contact.
  final String phone;

  /// Remote profile photo URL or null if default avatar is used.
  final String? avatar;

  /// Optional gender identity string.
  final String? gender;

  /// Date of birth formatted string.
  final String? dob;

  /// Role definition (e.g. "CUSTOMER", "RIDER", "ADMIN").
  final String role;

  /// Whether the customer's phone number has been verified via OTP.
  final bool isPhoneVerified;

  /// Customer-selected food preferences (e.g., "100% Halal", "Low Spice").
  final List<String> dietaryPreferences;

  /// Health and lifestyle goals (e.g., "Weight Management", "High Protein").
  final List<String> healthGoals;

  /// Creates a [UserModel] instance.
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.gender,
    this.dob,
    required this.role,
    this.isPhoneVerified = false,
    this.dietaryPreferences = const [],
    this.healthGoals = const [],
  });

  /// Constructs a [UserModel] from a backend JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      role: json['role']?.toString() ?? 'CUSTOMER',
      isPhoneVerified: json['isPhoneVerified'] == true || json['isVerified'] == true,
      dietaryPreferences: (json['dietaryPreferences'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      healthGoals: (json['healthGoals'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  /// Serializes this [UserModel] to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'gender': gender,
      'dob': dob,
      'role': role,
      'isPhoneVerified': isPhoneVerified,
      'dietaryPreferences': dietaryPreferences,
      'healthGoals': healthGoals,
    };
  }

  /// Creates a modified copy of this [UserModel].
  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? gender,
    String? dob,
    List<String>? dietaryPreferences,
    List<String>? healthGoals,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      role: role,
      isPhoneVerified: isPhoneVerified,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      healthGoals: healthGoals ?? this.healthGoals,
    );
  }
}
