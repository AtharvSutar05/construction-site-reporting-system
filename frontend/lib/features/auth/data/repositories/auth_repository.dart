import 'package:flutter/foundation.dart';
import 'package:frontend/core/services/secure_storage_service.dart';
import 'package:frontend/features/auth/data/models/login_request.dart';
import 'package:frontend/features/auth/data/models/register_request.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';
import 'package:frontend/features/auth/data/services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _authApiService = AuthApiService();
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<UserModel> login(LoginRequest loginRequest) async {
    final loginResponse = await _authApiService.login(loginRequest);
    if(!kIsWeb) {
      await _secureStorageService.saveAccessToken(loginResponse.data.token);
    }
    return loginResponse.data.user;
  }

  Future<UserModel> register(RegisterRequest registerRequest) async {
    final registerResponse = await _authApiService.register(registerRequest);
    if(!kIsWeb) {
      await _secureStorageService.saveAccessToken(registerResponse.data.token);
    }
    return registerResponse.data.user;
  }

  Future<UserModel?> me() async {
    final user = await _authApiService.me();
    return user;
  }

  Future<void> logOut() async {
    await _authApiService.logOut();
  }
}