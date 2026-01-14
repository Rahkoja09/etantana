import 'package:equatable/equatable.dart';

class ProductState<T> extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final T? product;

  const ProductState({this.isLoading = false, this.errorMessage, this.product});

  ProductState copyWith({
    bool? isLoading,
    String? errorMessage,
    T? product,
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
