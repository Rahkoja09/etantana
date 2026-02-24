import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/product/domain/action/product_actions.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:equatable/equatable.dart';

class ProductState<T> extends Equatable {
  final bool isLoading;
  final Failure? error;
  final ProductActions? action;
  final String? errorCode;
  final List<ProductEntities>? product;
  final ProductEntities? currentCriteria;

  const ProductState({
    this.isLoading = false,
    this.error,
    this.product,
    this.action,
    this.errorCode,
    this.currentCriteria,
  });

  ProductState copyWith({
    bool? isLoading,
    Failure? error,
    List<ProductEntities>? product,
    String? errorCode,
    ProductActions? action,
    bool isClearError = false,
    final ProductEntities? currentCriteria,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      error: isClearError == true ? null : (error ?? this.error),
      product: product ?? this.product,
      action: action ?? this.action,
      errorCode: errorCode ?? this.errorCode,
      currentCriteria: currentCriteria ?? this.currentCriteria,
    );
  }

  @override
  List<Object?> get props => [
    error,
    product,
    isLoading,
    errorCode,
    action,
    currentCriteria,
  ];
}
