import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/data/models/login_request.dart';
import 'package:frontend/features/auth/data/models/register_request.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final LoginRequest loginRequest;

  const LoginRequested({required this.loginRequest});

  @override
  List<Object?> get props => [loginRequest];
}

class RegisterRequested extends AuthEvent {
  final RegisterRequest registerRequest;

  const RegisterRequested({required this.registerRequest});

  @override
  List<Object?> get props => [registerRequest];
}

class AuthCheckRequested extends AuthEvent {}

class LogOutRequested extends AuthEvent {}