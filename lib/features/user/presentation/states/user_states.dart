import 'package:equatable/equatable.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';
import 'package:e_tantana/features/user/domain/actions/user_actions.dart';

class UserStates extends Equatable {
  final bool isLoading;
  final Failure? error;
  final List<UserEntity>? users;
  final UserEntity? currentCriteria;
  final UserActions? action;
  final String? errorCode;

  const UserStates({
    this.isLoading = false,
    this.error,
    this.users,
    this.currentCriteria,
    this.action,
    this.errorCode,
  });

  UserStates copyWith({
    bool? isLoading,
    List<UserEntity>? users,
    UserEntity? currentCriteria,
    UserActions? action,
    String? errorCode,
    Failure? error,
    bool isClearError = false,
  }) {
    return UserStates(
      isLoading: isLoading ?? this.isLoading,
      error: isClearError == true ? null : (error ?? this.error),
      users: users ?? this.users,
      currentCriteria: currentCriteria ?? this.currentCriteria,
      action: action ?? this.action,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        users,
        currentCriteria,
        action,
        errorCode,
      ];
}