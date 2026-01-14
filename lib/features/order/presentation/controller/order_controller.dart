import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/usecases/order_usecases.dart';
import 'package:e_tantana/features/order/presentation/states/order_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderController extends StateNotifier<OrderStates> {
  final OrderUsecases _orderUsecases;

  OrderController(this._orderUsecases) : super(OrderStates());

  Future<void> getOrderById(String orderId) async {
    _setLoadingState();
    final res = await _orderUsecases.getOrderById(orderId);
    _setSuccesOrErrorState<OrderEntities>(res);
  }

  Future<void> insertOrder(OrderEntities entity) async {
    _setLoadingState();
    final res = await _orderUsecases.insertOrder(entity);
    _setSuccesOrErrorState<OrderEntities>(res);
  }

  Future<void> deleteOrderById(String orderId) async {
    _setLoadingState();
    final res = await _orderUsecases.deleteOrderById(orderId);
    _setSuccesOrErrorState<void>(res);
  }

  Future<void> updateOrder(OrderEntities entity) async {
    _setLoadingState();
    final res = await _orderUsecases.updateOrder(entity);
    _setSuccesOrErrorState<OrderEntities>(res);
  }

  Future<void> researchOrder(OrderEntities? criterial) async {
    _setLoadingState();
    final res = await _orderUsecases.researchOrder(criterial);
    _setSuccesOrErrorState<List<OrderEntities>>(res);
  }

  // set new state by folding (error and success) -----------
  void _setSuccesOrErrorState<T>(Either<Failure, T> res) {
    res.fold(
      (error) {
        state = state.copyWith(
          isLoading: false,
          isClearError: false,
          errorMessage: error.message,
          order: null,
        );
      },
      (successData) {
        state = state.copyWith(
          isLoading: false,
          isClearError: false,
          errorMessage: null,
          order: successData,
        );
      },
    );
  }

  // set loading state -------------------------------
  void _setLoadingState() {
    state = state.copyWith(
      isLoading: true,
      isClearError: false,
      errorMessage: null,
    );
  }
}

final orderControllerProvider =
    StateNotifierProvider<OrderController, OrderStates>((ref) {
      final orderUsecases = sl<OrderUsecases>();
      return OrderController(orderUsecases);
    });
