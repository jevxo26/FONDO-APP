class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? gender;
  final String? dob;
  final String role;
  final bool isPhoneVerified;
  final List<String> dietaryPreferences;
  final List<String> healthGoals;

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
