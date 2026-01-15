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
    res.fold((error) => _setError(error), (success) {
      final otherOrder =
          state.order?.where((p) => p.id != success.id).toList() ?? [];
      state = state.copyWith(isLoading: false, order: [success, ...otherOrder]);
    });
  }

  Future<void> insertOrder(OrderEntities entity) async {
    _setLoadingState();
    final res = await _orderUsecases.insertOrder(entity);
    res.fold((error) => _setError(error), (success) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        errorMessage: null,
        order: [success, ...?state.order],
      );
    });
  }

  Future<void> deleteOrderById(String orderId) async {
    _setLoadingState();
    final res = await _orderUsecases.deleteOrderById(orderId);
    res.fold((error) => _setError(error), (success) {
      final newList = state.order!.where((p) => p.id != orderId).toList();
      state = state.copyWith(isLoading: false, order: newList);
    });
  }

  Future<void> updateOrder(OrderEntities entity) async {
    _setLoadingState();
    final res = await _orderUsecases.updateOrder(entity);
    res.fold((error) => _setError(error), (updatedOrder) {
      final List<OrderEntities> currentOrder = state.order ?? [];
      final newOrderList =
          currentOrder.map<OrderEntities>((p) {
            return p.id == updatedOrder.id ? updatedOrder : p;
          }).toList();

      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        order: newOrderList,
      );
    });
  }

  Future<void> researchOrder(OrderEntities? criterial) async {
    _setLoadingState();
    final res = await _orderUsecases.researchOrder(criterial);
    res.fold((error) => _setError(error), (success) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        errorMessage: null,
        order: success,
      );
    });
  }

  void _setLoadingState() {
    state = state.copyWith(isLoading: true);
  }

  void _setError(Failure error) {
    state = state.copyWith(isLoading: false, errorMessage: error.message);
  }
}

final orderControllerProvider =
    StateNotifierProvider<OrderController, OrderStates>((ref) {
      final orderUsecases = sl<OrderUsecases>();
      return OrderController(orderUsecases);
    });
