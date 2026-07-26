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
    };
  }
}
