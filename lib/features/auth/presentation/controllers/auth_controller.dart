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

/// Single identity source for the current user across screens.
/// Falls back to default mock profile when unauthenticated for offline previews.
final currentUserProvider = Provider<UserModel>((ref) {
  final user = ref.watch(authControllerProvider.select((s) => s.user));
  return user ?? _demoUser;
});

/// Riverpod provider for managing application authentication state.
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  return AuthController(authRepository, storageService);
});

/// Controller handling customer session initialization, login, registration, OTP validation, and token lifecycle.
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _storageService;

  /// Creates an [AuthController] and initiates session bootstrap.
  AuthController(this._authRepository, this._storageService) : super(const AuthState()) {
    bootstrap();
  }

  /// Clears active error messages from state.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Updates authenticated user profile details in state.
  void updateUser(UserModel user) {
    state = state.copyWith(user: user);
  }

  /// Restores existing session credentials from secure storage and retrieves current profile.
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

  /// Authenticates user with credentials, stores JWT tokens, and populates user session.
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

  /// Submits customer registration request to the backend.
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

  /// Validates SMS OTP code, saves returned session token, and establishes authenticated state.
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

  /// Persists a new destination address to the customer's profile.
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

  /// Dispatches password reset code or instructions to customer identity.
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

  /// Resets customer password using confirmation token.
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

  /// Clears stored authentication session and transitions to unauthenticated state.
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
