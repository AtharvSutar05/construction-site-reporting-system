import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/config/env_config.dart';
import 'package:frontend/core/network/http_client_factory.dart';
import 'package:frontend/core/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? createHttpClient();

  final String _baseUrl = EnvConfig.apiBaseUrl;
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Map<String, String>> _buildHeaders() async {
    String? token;
    if (!kIsWeb) {
      token = await _secureStorageService.readAccessToken();
    }
    if (token == null) {
      return {'Content-Type': 'application/json'};
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> get(String route) async {
    final http.Response response = await _client.get(
      Uri.parse("$_baseUrl/$route"),
      headers: await _buildHeaders(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String route,
    Map<String, dynamic> body,
  ) async {
    try {
      final http.Response response = await _client.post(
        Uri.parse("$_baseUrl/$route"),
        headers: await _buildHeaders(),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch(e) {
      throw ApiException(
        statusCode: 0,
        message: "Network error. Please check your internet connection.",
      );
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    // 1. Try to extract error message sent by your backend API response
    String? serverMessage;
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body.containsKey('message')) {
        serverMessage = body['message'];
      }
    } catch (_) {}

    // 2. Fallback based on status code
    switch (response.statusCode) {
      case 400:
        throw ApiException(
          statusCode: 400,
          message: serverMessage ?? "Invalid request. Please check your input.",
        );
      case 401:
        throw ApiException(
          statusCode: 401,
          message: serverMessage ?? "Invalid credentials.",
        );
      case 403:
        throw ApiException(
          statusCode: 403,
          message: serverMessage ?? "Access denied.",
        );
      case 404:
        throw ApiException(
          statusCode: 404,
          message: serverMessage ?? "Resource not found.",
        );
      case 500:
      case 502:
      case 503:
        throw ApiException(
          statusCode: response.statusCode,
          message: "Server Issue! Please try again later.",
        );
      default:
        throw ApiException(
          statusCode: response.statusCode,
          message: serverMessage ?? "Something went wrong (${response.statusCode}).",
        );
    }
  }
}
