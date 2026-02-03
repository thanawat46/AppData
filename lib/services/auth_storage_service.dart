import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorageService {
  final _storage = const FlutterSecureStorage();

  static const _keyQuota = 'saved_quota';
  static const _keyPassword = 'saved_password';
  static const _keyRememberMe = 'remember_me';

  Future<void> saveCredentials(String quota, String password, bool rememberMe) async {
    try {
      if (rememberMe) {
        await _storage.write(key: _keyQuota, value: quota);
        await _storage.write(key: _keyPassword, value: password);
        await _storage.write(key: _keyRememberMe, value: 'true');
      } else {
        await clearCredentials();
      }
    } catch (e) {
      print("Storage Error (Save): $e");
    }
  }

  Future<Map<String, String?>> getCredentials() async {
    try {
      String? isRemember = await _storage.read(key: _keyRememberMe);
      if (isRemember == 'true') {
        return {
          'quota': await _storage.read(key: _keyQuota),
          'password': await _storage.read(key: _keyPassword),
          'isRemember': 'true',
        };
      }
    } catch (e) {
      print("Storage Error (Read): $e");
    }
    return {'isRemember': 'false'};
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _keyQuota);
    await _storage.delete(key: _keyPassword);
    await _storage.write(key: _keyRememberMe, value: 'false');
  }

  Future<void> updateLastActive() async {
    final now = DateTime.now().toIso8601String();
    await _storage.write(key: 'last_active', value: now);
  }

  Future<DateTime?> getLastActive() async {
    final stringTime = await _storage.read(key: 'last_active');
    if (stringTime == null) return null;
    return DateTime.tryParse(stringTime);
  }
}