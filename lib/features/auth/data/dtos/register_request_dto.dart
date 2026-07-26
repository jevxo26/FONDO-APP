class RegisterRequestDto {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;

  const RegisterRequestDto({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.role = 'CUSTOMER',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }
}
