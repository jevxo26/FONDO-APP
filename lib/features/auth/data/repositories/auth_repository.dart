import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../models/address_model.dart';
import '../../../../models/user_model.dart';
import '../dtos/auth_response_dto.dart';
import '../dtos/login_request_dto.dart';
import '../dtos/otp_verify_dto.dart';
import '../dtos/register_request_dto.dart';

/// Riverpod provider exposing the configured [AuthRepository].
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRepository(dioClient.dio);
});

/// Remote authentication repository managing customer session calls and user endpoints.
class AuthRepository {
  /// Underlying HTTP client instance.
  final Dio dio;

  /// Creates an [AuthRepository] with the given [Dio] client.
  AuthRepository(this.dio);

  /// Authenticates a customer using credentials and returns tokens and user profile.
  Future<AuthResponseDto> login(LoginRequestDto dto) async {
    try {
      final response = await dio.post(ApiEndpoints.login, data: dto.toJson());
      return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppException ? e.error as AppException : AppException(message: e.message ?? 'Login failed');
    }
  }

  /// Registers a new customer account and initiates session tokens.
  Future<AuthResponseDto> register(RegisterRequestDto dto) async {
    try {
      final response = await dio.post(ApiEndpoints.register, data: dto.toJson());
      return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppException ? e.error as AppException : AppException(message: e.message ?? 'Registration failed');
    }
  }

  /// Dispatches an SMS verification OTP to the specified phone number.
  Future<bool> sendOtp(String phone) async {
    try {
      final response = await dio.post(ApiEndpoints.sendOtp, data: {'phone': phone});
      final data = response.data as Map<String, dynamic>;
      return data['success'] == true;
    } on DioException catch (e) {
      throw e.error is AppException ? e.error as AppException : AppException(message: e.message ?? 'Failed to send OTP');
    }
  }

  /// Validates a phone OTP code and authenticates the customer session.
  Future<AuthResponseDto> verifyOtp(OtpVerifyDto dto) async {
    try {
      final response = await dio.post(ApiEndpoints.verifyOtp, data: dto.toJson());
      return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppException ? e.error as AppException : AppException(message: e.message ?? 'OTP verification failed');
    }
  }

  /// Sends a password recovery instruction to the customer email or phone.
  Future<bool> forgotPassword(String identity) async {
    try {
      final isEmail = identity.contains('@');
      final payload = isEmail ? {'email': identity} : {'phone': identity};
      final response = await dio.post(ApiEndpoints.forgotPassword, data: payload);
      final data = response.data as Map<String, dynamic>;
      return data['success'] == true;
    } on DioException catch (e) {
      throw e.error is AppException ? e.error as AppException : AppException(message: e.message ?? 'Forgot password request failed');
    }
  }

  /// Resets customer password using recovery code.
  Future<bool> resetPassword({required String code, required String newPassword, String? identity}) async {
    try {
      final payload = {
        'code': code,
        'newPassword': newPassword,
        'identity': ?identity,
      };
      final response = await dio.post(ApiEndpoints.resetPassword, data: payload);
      final data = response.data as Map<String, dynamic>;
      return data['success'] == true;
    } on DioException catch (e) {
      throw e.error is AppException ? e.error as AppException : AppException(message: e.message ?? 'Reset password failed');
    }
  }

  /// Retrieves the current authenticated user's remote profile record.
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get(ApiEndpoints.me);
      final data = response.data as Map<String, dynamic>;
      final userJson = data['data'] ?? data['user'] ?? data;
      return UserModel.fromJson(userJson as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppException ? e.error as AppException : AppException(message: e.message ?? 'Failed to get user profile');
    }
  }

  /// Fetches customer saved delivery destination addresses.
  Future<List<AddressModel>> getUserAddresses() async {
    try {
      final response = await dio.get(ApiEndpoints.userAddresses);
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List? ?? [];
      return list.map((e) => AddressModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw e.error is AppException ? e.error as AppException : AppException(message: e.message ?? 'Failed to fetch addresses');
    }
  }

  /// Persists a new delivery destination address for the customer.
  Future<AddressModel> addAddress(AddressModel address) async {
    try {
      final response = await dio.post(ApiEndpoints.userAddresses, data: address.toJson());
      final data = response.data as Map<String, dynamic>;
      final item = data['data'] ?? data;
      return AddressModel.fromJson(item as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppException ? e.error as AppException : AppException(message: e.message ?? 'Failed to save address');
    }
  }
}
