class LoginRequestDto {
  final String identity; // email or phone
  final String password;

  const LoginRequestDto({
    required this.identity,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final isEmail = identity.contains('@');
    return {
      if (isEmail) 'email': identity else 'phone': identity,
      'password': password,
    };
  }
}
