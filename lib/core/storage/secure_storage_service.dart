import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  static const String _kAccessTokenKey = 'fondo_access_token';
  static const String _kRefreshTokenKey = 'fondo_refresh_token';
  static const String _kUserIdKey = 'fondo_user_id';

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _kAccessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _kAccessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _kRefreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _kRefreshTokenKey);
  }

  Future<void> saveUserId(String id) async {
    await _storage.write(key: _kUserIdKey, value: id);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _kUserIdKey);
  }

  Future<void> clearAuthSession() async {
    await _storage.delete(key: _kAccessTokenKey);
    await _storage.delete(key: _kRefreshTokenKey);
    await _storage.delete(key: _kUserIdKey);
  }
}
