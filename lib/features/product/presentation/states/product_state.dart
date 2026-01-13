import 'package:e_tantana/features/product/domain/entities/product_entities.dart';

class ProductState<T> {
  bool isLoading;
  String? errorMessage;
  T? product;

  ProductState({this.isLoading = false, this.errorMessage, this.product});

  ProductState copyWith({
    bool? isLoading,
    String? errorMessage,
    T? product,
    bool isClearError = true,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: isClearError ? null : (errorMessage ?? this.errorMessage),
      product: product ?? this.product,
    );
  }
}
