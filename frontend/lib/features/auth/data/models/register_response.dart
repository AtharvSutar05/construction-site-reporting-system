import 'package:frontend/features/auth/data/models/auth_data.dart';

class RegisterResponse {
  final bool success;
  final String message;
  final AuthData data;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'],
      message: json['message'],
      data: AuthData.fromJson(json['data']),
    );
  }
}
