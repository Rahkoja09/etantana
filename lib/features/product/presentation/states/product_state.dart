import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:equatable/equatable.dart';

class ProductState<T> extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<ProductEntities>? product;
  final ProductEntities? currentCriteria;

  const ProductState({
    this.isLoading = false,
    this.errorMessage,
    this.product,
    this.currentCriteria,
  });

  ProductState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ProductEntities>? product,
    bool isClearError = false,
    final ProductEntities? currentCriteria,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          isClearError == true ? null : (errorMessage ?? this.errorMessage),
      product: product ?? this.product,
      currentCriteria: currentCriteria ?? this.currentCriteria,
    );
  }

  @override
  List<Object?> get props => [
    errorMessage,
    product,
    isLoading,
    currentCriteria,
  ];
}
