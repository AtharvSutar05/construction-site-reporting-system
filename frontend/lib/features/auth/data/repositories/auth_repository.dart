import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:frontend/core/services/secure_storage_service.dart';
import 'package:frontend/features/auth/data/models/login_request.dart';
import 'package:frontend/features/auth/data/models/register_request.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';
import 'package:frontend/features/auth/data/services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _authApiService;
  final SecureStorageService _secureStorageService;

  AuthRepository({
    AuthApiService? authApiService,
    SecureStorageService? secureStorageService,
  }) : _authApiService = authApiService ?? AuthApiService(),
       _secureStorageService = secureStorageService ?? SecureStorageService();

  Future<UserModel> login(LoginRequest loginRequest) async {
    final loginResponse = await _authApiService.login(loginRequest);
    if (!kIsWeb) {
      await _secureStorageService.saveAccessToken(loginResponse.data.token);
    }
    return loginResponse.data.user;
  }

  Future<UserModel> register(RegisterRequest registerRequest) async {
    final registerResponse = await _authApiService.register(registerRequest);
    if (!kIsWeb) {
      await _secureStorageService.saveAccessToken(registerResponse.data.token);
    }
    return registerResponse.data.user;
  }

  Future<void> logOut() async {
    if (!kIsWeb) {
      await _secureStorageService.deleteAccessToken();
      return;
    }
    await _authApiService.logOut();
  }

  Future<UserModel?> restoreSession() async {
    if (!kIsWeb) {
      final token = await _secureStorageService.readAccessToken();
      if (token == null || token.isEmpty) {
        return null;
      }
    }
    return await _authApiService.me();
  }

  Future<void> clearLocalSession() async {
    if (!kIsWeb) {
      await _secureStorageService.deleteAccessToken();
    }
  }
}
