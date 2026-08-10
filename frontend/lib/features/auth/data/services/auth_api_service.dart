import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/auth/data/models/login_request.dart';
import 'package:frontend/features/auth/data/models/login_response.dart';
import 'package:frontend/features/auth/data/models/register_request.dart';
import 'package:frontend/features/auth/data/models/register_response.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';

class AuthApiService {
  final ApiClient _apiClient = ApiClient();

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final json = await _apiClient.post('auth/login', loginRequest.toJson());
    return LoginResponse.fromJson(json);
  }

  Future<RegisterResponse> register(RegisterRequest registerRequest) async {
    final json = await _apiClient.post(
      'auth/register',
      registerRequest.toJson(),
    );
    return RegisterResponse.fromJson(json);
  }

  Future<UserModel> me() async {
    final json = await _apiClient.get('auth/me');
    return UserModel.fromJson(json['data']);
  }

  Future<void> logOut() async {
    await _apiClient.get('auth/logout');
  }
}
