import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:equatable/equatable.dart';

class ProductState<T> extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<ProductEntities>? product;

  const ProductState({this.isLoading = false, this.errorMessage, this.product});

  ProductState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ProductEntities>? product,
    bool isClearError = false,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          isClearError == true ? null : (errorMessage ?? this.errorMessage),
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [errorMessage, product, isLoading];
}
