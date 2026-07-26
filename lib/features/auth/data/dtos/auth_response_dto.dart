import '../../../../models/user_model.dart';

class AuthResponseDto {
  final bool success;
  final String message;
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;

  const AuthResponseDto({
    required this.success,
    required this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    UserModel? userModel;
    String? token;
    String? refToken;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('user')) {
        userModel = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      } else {
        userModel = UserModel.fromJson(data);
      }
      token = data['accessToken']?.toString() ?? data['token']?.toString();
      refToken = data['refreshToken']?.toString();
    } else if (json.containsKey('user')) {
      userModel = UserModel.fromJson(json['user'] as Map<String, dynamic>);
      token = json['accessToken']?.toString() ?? json['token']?.toString();
      refToken = json['refreshToken']?.toString();
    }

    return AuthResponseDto(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      user: userModel,
      accessToken: token,
      refreshToken: refToken,
    );
  }
}
