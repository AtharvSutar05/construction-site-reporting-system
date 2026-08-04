import 'user_model.dart';

class AuthData {
  final String token;
  final UserModel user;

  AuthData({required this.token, required this.user});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }
}