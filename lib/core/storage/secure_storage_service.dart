import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Riverpod provider for encrypted customer credential storage.
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

/// Service managing hardware-backed keychain and Keystore credential storage.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  /// Creates a [SecureStorageService] with the provided [FlutterSecureStorage] instance.
  SecureStorageService(this._storage);

  static const String _kAccessTokenKey = 'fondo_access_token';
  static const String _kRefreshTokenKey = 'fondo_refresh_token';
  static const String _kUserIdKey = 'fondo_user_id';

  /// Persists customer JWT bearer access token to secure storage.
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _kAccessTokenKey, value: token);
  }

  /// Retrieves persisted customer JWT access token or null if unauthenticated.
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _kAccessTokenKey);
  }

  /// Persists long-lived session refresh token to secure storage.
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _kRefreshTokenKey, value: token);
  }

  /// Retrieves long-lived session refresh token or null if unavailable.
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _kRefreshTokenKey);
  }

  /// Persists authenticated user identifier.
  Future<void> saveUserId(String id) async {
    await _storage.write(key: _kUserIdKey, value: id);
  }

  /// Retrieves authenticated user identifier or null.
  Future<String?> getUserId() async {
    return await _storage.read(key: _kUserIdKey);
  }

  /// Wipes all cached tokens and session identity credentials upon logout.
  Future<void> clearAuthSession() async {
    await _storage.delete(key: _kAccessTokenKey);
    await _storage.delete(key: _kRefreshTokenKey);
    await _storage.delete(key: _kUserIdKey);
  }
}
