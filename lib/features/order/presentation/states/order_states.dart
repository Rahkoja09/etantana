import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:equatable/equatable.dart';

class OrderStates<T> extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<OrderEntities>? order;
  final OrderEntities? currentCriteria;

  const OrderStates({
    this.isLoading = false,
    this.errorMessage,
    this.order,
    this.currentCriteria,
  });

  OrderStates copyWith({
    bool? isLoading,
    String? errorMessage,
    List<OrderEntities>? order,
    bool? isClearError = false,
    OrderEntities? currentCriteria,
  }) {
    return OrderStates(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          isClearError == true ? null : (errorMessage ?? this.errorMessage),
      order: order ?? this.order,
      currentCriteria: currentCriteria ?? this.currentCriteria,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, order, currentCriteria];
}
