import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../models/address_model.dart';
import '../../../../models/user_model.dart';
import '../../data/dtos/login_request_dto.dart';
import '../../data/dtos/otp_verify_dto.dart';
import '../../data/dtos/register_request_dto.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

const UserModel _demoUser = UserModel(
  id: 'usr_demo_001',
  name: 'Raihan Ahmed',
  email: 'raihan@example.com',
  phone: '+8801712345678',
  avatar: null,
  gender: 'male',
  dob: '1995-06-15',
  role: 'CUSTOMER',
  isPhoneVerified: true,
);

/// Single identity source for the current user. In Phase A (mock-only, no live
/// session) it falls back to the demo identity so every screen renders.
final currentUserProvider = Provider<UserModel>((ref) {
  final user = ref.watch(authControllerProvider.select((s) => s.user));
  return user ?? _demoUser;
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  return AuthController(authRepository, storageService);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _storageService;

  AuthController(this._authRepository, this._storageService) : super(const AuthState()) {
    bootstrap();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void updateUser(UserModel user) {
    state = state.copyWith(user: user);
  }

  Future<void> bootstrap() async {
    try {
      state = state.copyWith(status: AuthStatus.initial);
      final token = await _storageService.getAccessToken();

      if (token == null || token.isEmpty) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }

      final user = await _authRepository.getCurrentUser();
      final addresses = await _fetchAddressesSafely();

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        addresses: addresses,
      );
    } catch (e) {
      await _storageService.clearAuthSession();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> login(LoginRequestDto dto) async {
    try {
      state = state.copyWith(status: AuthStatus.authenticating, errorMessage: null);
      final res = await _authRepository.login(dto);

      if (res.accessToken != null) {
        await _storageService.saveAccessToken(res.accessToken!);
      }

      if (res.user != null) {
        await _storageService.saveUserId(res.user!.id);
      }

      final user = res.user ?? await _authRepository.getCurrentUser();
      final addresses = await _fetchAddressesSafely();

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        addresses: addresses,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('AppException: ', ''),
      );
      return false;
    }
  }

  Future<bool> register(RegisterRequestDto dto) async {
    try {
      state = state.copyWith(status: AuthStatus.authenticating, errorMessage: null);
      final res = await _authRepository.register(dto);
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return res.success;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('AppException: ', ''),
      );
      return false;
    }
  }

  Future<bool> verifyOtpAndAutoLogin(OtpVerifyDto dto) async {
    try {
      state = state.copyWith(status: AuthStatus.authenticating, errorMessage: null);
      final res = await _authRepository.verifyOtp(dto);

      if (res.accessToken != null) {
        await _storageService.saveAccessToken(res.accessToken!);
      }

      if (res.user != null) {
        await _storageService.saveUserId(res.user!.id);
      }

      final user = res.user ?? await _authRepository.getCurrentUser();
      final addresses = await _fetchAddressesSafely();

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        addresses: addresses,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('AppException: ', ''),
      );
      return false;
    }
  }

  Future<bool> addAddress(AddressModel address) async {
    try {
      final savedAddress = await _authRepository.addAddress(address);
      final updatedAddresses = [...state.addresses, savedAddress];
      state = state.copyWith(addresses: updatedAddresses);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> forgotPassword(String identity) async {
    try {
      state = state.copyWith(status: AuthStatus.authenticating, errorMessage: null);
      return await _authRepository.forgotPassword(identity);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('AppException: ', ''),
      );
      return false;
    }
  }

  Future<bool> resetPassword({required String code, required String newPassword, String? identity}) async {
    try {
      state = state.copyWith(status: AuthStatus.authenticating, errorMessage: null);
      return await _authRepository.resetPassword(code: code, newPassword: newPassword, identity: identity);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('AppException: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _storageService.clearAuthSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<List<AddressModel>> _fetchAddressesSafely() async {
    try {
      return await _authRepository.getUserAddresses();
    } catch (_) {
      return [];
    }
  }
}
