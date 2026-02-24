import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/order/domain/actions/order_actions.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:equatable/equatable.dart';

class OrderStates<T> extends Equatable {
  final bool isLoading;
  final Failure? error;
  final List<OrderEntities>? order;
  final OrderEntities? currentCriteria;
  final OrderActions? action;
  final String? errorCode;

  const OrderStates({
    this.isLoading = false,
    this.error,
    this.order,
    this.currentCriteria,
    this.action,
    this.errorCode,
  });

  OrderStates copyWith({
    bool? isLoading,
    List<OrderEntities>? order,
    bool? isClearError = false,
    OrderEntities? currentCriteria,
    OrderActions? action,
    String? errorCode,
    Failure? error,
  }) {
    return OrderStates(
      isLoading: isLoading ?? this.isLoading,
      error: isClearError == true ? null : (error ?? this.error),
      order: order ?? this.order,
      currentCriteria: currentCriteria ?? this.currentCriteria,
      action: action ?? this.action,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    order,
    currentCriteria,
    action,
    errorCode,
  ];
}
