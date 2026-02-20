import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/usecases/order_usecases.dart';
import 'package:e_tantana/features/order/presentation/states/order_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderController extends StateNotifier<OrderStates> {
  final OrderUsecases _orderUsecases;

  int _currentPage = 0;
  final int _pageSize = 6;
  bool _isLastPage = false;

  OrderController(this._orderUsecases) : super(OrderStates());

  // --- RÉCUPÉRATION / RECHERCHE ---
  Future<void> researchOrder(OrderEntities? criteria) async {
    final action = orderAction.searchOrder;
    _currentPage = 0;
    _isLastPage = false;

    _setLoadingState(action: action);

    state = state.copyWith(
      currentCriteria: criteria,
      order: [],
      isLoading: true,
      action: action,
    );

    final res = await _orderUsecases.researchOrder(
      criteria,
      start: 0,
      end: _pageSize - 1,
    );

    res.fold((error) => _setError(error: error, action: action), (success) {
      if (success.length < _pageSize) _isLastPage = true;
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        order: success,
        action: action,
      );
    });
  }

  // --- LAZY LOADING ---
  Future<void> loadNextPage() async {
    final action = orderAction.loadNextPage;
    if (state.isLoading || _isLastPage) return;

    _currentPage++;
    final int start = _currentPage * _pageSize;
    final int end = start + _pageSize - 1;

    // Pas de setLoadingState ici pour ne pas bloquer l'UI (spinner discret possible via state) --------
    final res = await _orderUsecases.researchOrder(
      state.currentCriteria,
      start: start,
      end: end,
    );

    res.fold((error) => _setError(error: error, action: action), (newOrders) {
      if (newOrders.isEmpty) {
        _isLastPage = true;
      } else {
        if (newOrders.length < _pageSize) _isLastPage = true;
        state = state.copyWith(
          isLoading: false,
          order: [...?state.order, ...newOrders],
          action: action,
        );
      }
    });
  }

  // --- INSERTION (RPC COMPLETE ORDER) ---
  Future<void> placeCompleteOrder(OrderEntities entity) async {
    final action = orderAction.placeCompleteOrder;
    _setLoadingState(action: action);

    final res = await _orderUsecases.placeCompleteOrder(entity);

    res.fold((error) => _setError(error: error, action: action), (success) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        order: [success, ...?state.order],
        action: action,
      );
    });
  }

  // --- MISE À JOUR ---
  Future<void> updateOrderFlow(OrderEntities entity) async {
    final action = orderAction.updateOrder;
    _setLoadingState(action: action);

    final res = await _orderUsecases.updateOrderFlow(entity);

    res.fold((error) => _setError(error: error, action: action), (
      updatedOrder,
    ) {
      final newList =
          state.order
              ?.map((o) => o.id == updatedOrder.id ? updatedOrder : o)
              .toList() ??
          [];
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        order: newList,
        action: action,
      );
    });
  }

  // --- SUPPRESSION ---
  Future<void> deleteOrderById(String orderId) async {
    final action = orderAction.deleteOrder;
    _setLoadingState(action: action);

    final res = await _orderUsecases.deleteOrderById(orderId);

    res.fold((error) => _setError(error: error, action: action), (success) {
      final newList = state.order?.where((o) => o.id != orderId).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        order: newList,
        action: action,
      );
    });
  }

  // --- RÉCUPÉRATION PAR ID ---
  Future<void> getOrderById(String orderId) async {
    final action = orderAction.getOrder;
    _setLoadingState(action: action);

    final res = await _orderUsecases.getOrderById(orderId);

    res.fold((error) => _setError(error: error, action: action), (success) {
      final otherOrders =
          state.order?.where((o) => o.id != success.id).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        order: [success, ...otherOrders],
        action: action,
      );
    });
  }

  // --- UTILITAIRES ---
  void updateCriteria(OrderEntities criteria) {
    state = state.copyWith(currentCriteria: criteria);
  }

  void _setLoadingState({required dynamic action}) {
    state = state.copyWith(isLoading: true, action: action);
  }

  void _setError({required Failure error, required dynamic action}) {
    state = state.copyWith(
      isLoading: false,
      isClearError: false,
      error: error,
      errorCode: error.code,
      action: action,
    );
  }

  // Getters
  int get currentPage => _currentPage;
  bool get isLastPage => _isLastPage;
}

final orderControllerProvider =
    StateNotifierProvider<OrderController, OrderStates>((ref) {
      final orderUsecases = sl<OrderUsecases>();
      return OrderController(orderUsecases);
    });
