import 'package:equatable/equatable.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:e_tantana/features/cart/domain/actions/cart_actions.dart';

class CartStates extends Equatable {
  final bool isLoading;
  final Failure? error;
  final List<CartEntity>? carts;
  final CartEntity? currentCriteria;
  final CartActions? action;
  final String? errorCode;

  const CartStates({
    this.isLoading = false,
    this.error,
    this.carts,
    this.currentCriteria,
    this.action,
    this.errorCode,
  });

  CartStates copyWith({
    bool? isLoading,
    List<CartEntity>? carts,
    CartEntity? currentCriteria,
    CartActions? action,
    String? errorCode,
    Failure? error,
    bool isClearError = false,
  }) {
    return CartStates(
      isLoading: isLoading ?? this.isLoading,
      error: isClearError == true ? null : (error ?? this.error),
      carts: carts ?? this.carts,
      currentCriteria: currentCriteria ?? this.currentCriteria,
      action: action ?? this.action,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        carts,
        currentCriteria,
        action,
        errorCode,
      ];
}