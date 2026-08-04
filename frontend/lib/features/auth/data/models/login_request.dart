class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  LoginRequest copyWith({String? email, String? password}) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }
}
