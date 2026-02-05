import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorageService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyQuota = 'saved_quota';
  static const _keyPassword = 'saved_password';
  static const _keyRememberMe = 'remember_me';
  static const String _keyDataUser = 'data_user';

  Future<void> saveCredentials(String quota, String password, bool rememberMe, {Map<String, dynamic>? dataUser}) async {
    try {
      if (rememberMe) {
        await _storage.write(key: _keyQuota, value: quota);
        await _storage.write(key: _keyPassword, value: password);
        await _storage.write(key: _keyRememberMe, value: 'true');

        if (dataUser != null) {
          String jsonStr = jsonEncode(dataUser);
          await _storage.write(key: _keyDataUser, value: jsonStr);
        }
      } else {
        await clearCredentials();
      }
    } catch (e) {
      print("Storage Error (Save): $e");
    }
  }

  Future<Map<String, dynamic>> getCredentials() async {
    try {
      String? isRemember = await _storage.read(key: _keyRememberMe);
      if (isRemember == 'true') {
        String? jsonStr = await _storage.read(key: _keyDataUser);

        return {
          'quota': await _storage.read(key: _keyQuota),
          'password': await _storage.read(key: _keyPassword),
          'isRemember': 'true',
          'userData': jsonStr != null ? jsonDecode(jsonStr) : null,
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
    await _storage.delete(key: _keyDataUser);
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