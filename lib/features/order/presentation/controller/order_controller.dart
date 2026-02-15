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

  //   RÉCUPÉRATION ----------
  Future<void> researchOrder(OrderEntities? criterial) async {
    _currentPage = 0;
    _isLastPage = false;

    _setLoadingState();

    state = state.copyWith(currentCriteria: criterial);

    final res = await _orderUsecases.researchOrder(
      state.currentCriteria,
      start: 0,
      end: _pageSize - 1,
    );

    res.fold((error) => _setError(error), (success) {
      if (success.length < _pageSize) _isLastPage = true;
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        errorMessage: null,
        order: success,
      );
    });
  }

  //  CHARGEMENT DE LA PAGE SUIVANTE (Lazy Loading) --------
  Future<void> loadNextPage() async {
    if (state.isLoading || _isLastPage) return;

    _currentPage++;
    final int start = _currentPage * _pageSize;
    final int end = start + _pageSize - 1;

    final res = await _orderUsecases.researchOrder(
      state.currentCriteria,
      start: start,
      end: end,
    );

    res.fold((error) => _setError(error), (newOrders) {
      if (newOrders.isEmpty) {
        _isLastPage = true;
      } else {
        if (newOrders.length < _pageSize) _isLastPage = true;

        state = state.copyWith(
          isLoading: false,
          order: [...?state.order, ...newOrders],
        );
      }
    });
  }

  //  INSERTION ---è--------
  Future<void> processOrderFlow(OrderEntities entity) async {
    _setLoadingState();
    final res = await _orderUsecases.processOrderFlow(entity);
    res.fold((error) => _setError(error), (success) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        errorMessage: null,
        order: [
          success,
          ...?state.order,
        ], // Nouvelle commande en haut -----------------
      );
    });
  }

  //  MISE À JOUR ---((()))
  Future<void> updateOrderFlow(OrderEntities entity) async {
    _setLoadingState();
    final res = await _orderUsecases.updateOrderFlow(entity);
    res.fold((error) => _setError(error), (updatedOrder) {
      final newList =
          state.order
              ?.map((o) => o.id == updatedOrder.id ? updatedOrder : o)
              .toList() ??
          [];
      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        order: newList,
      );
    });
  }

  //  SUPPRESSION -------
  Future<void> deleteOrderById(String orderId) async {
    _setLoadingState();
    final res = await _orderUsecases.deleteOrderById(orderId);
    res.fold((error) => _setError(error), (success) {
      final newList = state.order?.where((o) => o.id != orderId).toList() ?? [];
      state = state.copyWith(isLoading: false, order: newList);
    });
  }

  //   DÉTAILS --------
  Future<void> getOrderById(String orderId) async {
    _setLoadingState();
    final res = await _orderUsecases.getOrderById(orderId);
    res.fold((error) => _setError(error), (success) {
      final otherOrders =
          state.order?.where((o) => o.id != success.id).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        order: [
          success,
          ...otherOrders,
        ], // On remonte la commande en haut -----------
      );
    });
  }

  // UTILITAIRES --
  void updateCriterial(OrderEntities updateCriterial) {
    state = state.copyWith(currentCriteria: updateCriterial);
  }

  void _setLoadingState() {
    state = state.copyWith(isLoading: true);
  }

  void _setError(Failure error) {
    state = state.copyWith(
      isLoading: false,
      isClearError: false,
      errorMessage: error.message,
    );
  }

  // Getters pour l'UI ---
  int get currentPage => _currentPage;
  bool get isLastPage => _isLastPage;
}

final orderControllerProvider =
    StateNotifierProvider<OrderController, OrderStates>((ref) {
      final orderUsecases = sl<OrderUsecases>();
      return OrderController(orderUsecases);
    });
