import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/cart/domain/actions/cart_actions.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:e_tantana/features/cart/domain/usecases/cart_usecases.dart';
import 'package:e_tantana/features/cart/presentation/states/cart_states.dart';

class CartController extends StateNotifier<CartStates> {
  final CartUsecases _cartUsecases;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLastPage = false;

  CartController(this._cartUsecases) : super(const CartStates());

  // --- RÉCUPÉRATION / RECHERCHE ---
  Future<void> searchCart(CartEntity? criteria) async {
    final action = SearchCartAction(criteria?.id ?? "tous");
    _currentPage = 0;
    _isLastPage = false;

    _setLoadingState(action: action);

    state = state.copyWith(
      currentCriteria: criteria,
      carts: [],
      isLoading: true,
      action: action,
    );

    final res = await _cartUsecases.searchCart(
      criteria: criteria,
      start: 0,
      end: _pageSize - 1,
    );

    res.fold((error) => _setError(error: error, action: action), (success) {
      if (success.length < _pageSize) _isLastPage = true;
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        carts: success,
        currentCriteria: criteria,
        action: action,
      );
    });
  }

  // --- LAZY LOADING (PAGINATION) ---
  Future<void> loadNextPage() async {
    if (state.isLoading || _isLastPage) return;

    final action = GetCartAction();
    _currentPage++;
    final int start = _currentPage * _pageSize;
    final int end = start + _pageSize - 1;

    final res = await _cartUsecases.searchCart(
      criteria: state.currentCriteria,
      start: start,
      end: end,
    );

    res.fold(
      (error) {
        _currentPage--; // Backtrack sur l'erreur
        _setError(error: error, action: action);
      },
      (newcarts) {
        if (newcarts.isEmpty) {
          _isLastPage = true;
        } else {
          if (newcarts.length < _pageSize) _isLastPage = true;
          state = state.copyWith(
            isLoading: false,
            carts: [...?state.carts, ...newcarts],
            action: action,
          );
        }
      },
    );
  }

  // --- INSERTION ---
  Future<void> createCart(CartEntity entity) async {
    final action = CreateCartAction(entity.id ?? "nouveau");
    _setLoadingState(action: action);

    final res = await _cartUsecases.insertCart(entity);

    res.fold((error) => _setError(error: error, action: action), (success) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        carts: [success, ...?state.carts],
        action: action,
      );
    });
  }

  // --- MISE À JOUR ---
  Future<void> updateCart(CartEntity entity) async {
    final action = UpdateCartAction(entity.id ?? "inconnu");
    _setLoadingState(action: action);

    final res = await _cartUsecases.updateCart(entity);

    res.fold((error) => _setError(error: error, action: action), (
      updatedEntity,
    ) {
      final newList =
          state.carts?.map((item) {
            return item.id == updatedEntity.id ? updatedEntity : item;
          }).toList();

      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        carts: newList,
        action: action,
      );
    });
  }

  // --- SUPPRESSION ---
  Future<void> deleteCartById(String id) async {
    final action = DeleteCartAction(id);
    _setLoadingState(action: action);

    final res = await _cartUsecases.deleteCartById(id);

    res.fold((error) => _setError(error: error, action: action), (_) {
      final newList = state.carts?.where((i) => i.id != id).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        carts: newList,
        action: action,
      );
    });
  }

  // --- UTILITAIRES INTERNES ---
  void _setLoadingState({required CartActions action}) {
    state = state.copyWith(isLoading: true, action: action);
  }

  void _setError({required Failure error, required CartActions action}) {
    state = state.copyWith(
      isLoading: false,
      error: error,
      errorCode: error.code,
      action: action,
    );
  }
}

// --- PROVIDER ---
final cartControllerProvider =
    StateNotifierProvider<CartController, CartStates>((ref) {
      return CartController(sl<CartUsecases>());
    });
