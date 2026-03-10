import 'package:equatable/equatable.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/auth/domain/entity/auth_entity.dart';
import 'package:e_tantana/features/auth/domain/actions/auth_actions.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, onboarding }

class AuthStates extends Equatable {
  final bool isLoading;
  final Failure? error;
  final AuthEntity? user;
  final AuthActions? action;
  final AuthStatus status;

  const AuthStates({
    this.isLoading = false,
    this.error,
    this.user,
    this.action,
    this.status = AuthStatus.initial,
  });

  AuthStates copyWith({
    bool? isLoading,
    AuthEntity? user,
    AuthActions? action,
    Failure? error,
    bool isClearError = false,
    AuthStatus? status,
  }) {
    return AuthStates(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      action: action ?? this.action,
      error: isClearError ? null : (error ?? this.error),
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, user, action, status];
}
