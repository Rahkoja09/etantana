import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';
import 'package:equatable/equatable.dart';

enum deliveringAction {
  deliveringInsert,
  deliveringDelete,
  deliveringUpdate,
  deliveringSearch,
  deliveringSelect,
  deliveringLoadNextPage,
}

class DeliveringStates extends Equatable {
  final bool isLoading;
  final deliveringAction? action;
  final Failure? error;
  final String? errorCode;
  final List<DeliveringEntity>? deliverings;
  final DeliveringEntity? currentCriteria;

  DeliveringStates({
    this.isLoading = false,
    this.error,
    this.deliverings,
    this.action,
    this.errorCode,
    this.currentCriteria,
  });

  DeliveringStates copyWith({
    bool? isLoading,
    bool? isClearError = false,
    Failure? error,
    deliveringAction? action,
    String? errorCode,
    List<DeliveringEntity>? deliverings,
    DeliveringEntity? currentCriteria,
  }) {
    return DeliveringStates(
      isLoading: isLoading ?? this.isLoading,
      error: isClearError == true ? null : (error ?? this.error),
      deliverings: deliverings ?? this.deliverings,
      action: action ?? this.action,
      errorCode: errorCode ?? this.errorCode,
      currentCriteria: currentCriteria ?? this.currentCriteria,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    deliverings,
    currentCriteria,
    action,
    errorCode,
  ];
}
