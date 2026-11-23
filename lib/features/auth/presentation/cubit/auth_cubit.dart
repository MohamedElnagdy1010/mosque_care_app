import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (state.status == AuthStatus.loading) return;

    emit(const AuthState(status: AuthStatus.loading));

    try {
      final user = await _repository.login(
        username: username,
        password: password,
      );

      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (error) {
      debugPrint('AUTH ERROR TYPE: ${error.runtimeType}');

      if (error is DioException) {
        debugPrint('AUTH HTTP STATUS: ${error.response?.statusCode}');
      }

      emit(
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'تعذر تسجيل الدخول. تحقق من البيانات وحاول مرة أخرى.',
        ),
      );
    }
  }

  Future<void> restoreSession() async {
    if (state.status == AuthStatus.loading) return;

    emit(const AuthState(status: AuthStatus.loading));

    try {
      final user = await _repository.restoreSession();

      if (isClosed) return;

      if (user == null) {
        emit(const AuthState(status: AuthStatus.initial));
        return;
      }

      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (error) {
      debugPrint('SESSION RESTORE ERROR: ${error.runtimeType}');

      if (isClosed) return;

      emit(
        const AuthState(
          status: AuthStatus.failure,
          errorMessage:
              'تعذر التحقق من جلسة الدخول. تحقق من الإنترنت وحاول مرة أخرى.',
        ),
      );
    }
  }

  Future<void> logout() async {
    if (state.status == AuthStatus.loading) return;

    emit(AuthState(status: AuthStatus.loading, user: state.user));

    try {
      await _repository.logout();
    } catch (error) {
      debugPrint('LOGOUT ERROR TYPE: ${error.runtimeType}');

      if (error is DioException) {
        debugPrint('LOGOUT HTTP STATUS: ${error.response?.statusCode}');
      }
    } finally {
      if (!isClosed) {
        emit(const AuthState(status: AuthStatus.initial));
      }
    }
  }
}
