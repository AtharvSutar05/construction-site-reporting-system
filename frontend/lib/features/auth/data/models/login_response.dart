import 'package:frontend/features/auth/data/models/user_model.dart';

import 'auth_data.dart';

class LoginResponse {
  final bool success;
  final String message;
  final AuthData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      data: AuthData.fromJson(json['data']),
    );
  }
}

