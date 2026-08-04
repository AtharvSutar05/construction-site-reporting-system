import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/secure_storage_service.dart';
import 'package:frontend/features/auth/data/repositories/auth_repository.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorageService _secureStorageService;
  final AuthRepository _authRepository;

  AuthBloc({
    SecureStorageService? secureStorageService,
    AuthRepository? authRepository,
  }) : _secureStorageService = secureStorageService ?? SecureStorageService(),
       _authRepository = authRepository ?? AuthRepository(),
       super(AuthInitial()) {
    on<LoginRequested>(onLoginRequested);
    on<RegisterRequested>(onRegisterRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LogOutRequested>(_onLogOutRequested);
  }

  Future<void> onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(event.loginRequest);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.register(event.registerRequest);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      if (!kIsWeb) {
        final token = await _secureStorageService.readAccessToken();
        if (token == null || token.isEmpty) {
          emit(AuthUnauthenticated());
          return;
        }
      }

      final user = await _authRepository.me();

      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthFailure(message: e.toString()));
      }
    }
  }

  Future<void> _onLogOutRequested(
    LogOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.logOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
