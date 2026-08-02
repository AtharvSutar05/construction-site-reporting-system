import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/constants/storage_keys.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: StorageKeys.accessToken, value: token);
  }

  Future<String?> readAccessToken() async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    return token;
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: StorageKeys.accessToken);
  }

  Future<void> clear() async {}
}
