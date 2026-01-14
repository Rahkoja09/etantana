import 'package:equatable/equatable.dart';

class OrderStates<T> extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final T? order;

  const OrderStates({this.isLoading = false, this.errorMessage, this.order});

  OrderStates copyWith({
    bool? isLoading,
    String? errorMessage,
    T? order,
    bool? isClearError = true,
  }) {
    return OrderStates(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          isClearError == true ? null : (errorMessage ?? this.errorMessage),
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, order];
}
