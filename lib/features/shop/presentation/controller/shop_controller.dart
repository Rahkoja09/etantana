import 'dart:io';

import 'package:e_tantana/core/app/session/session_controller.dart';
import 'package:e_tantana/features/user/presentation/controller/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/shop/domain/actions/shop_actions.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:e_tantana/features/shop/domain/usecases/shop_usecases.dart';
import 'package:e_tantana/features/shop/presentation/states/shop_states.dart';

class ShopController extends StateNotifier<ShopStates> {
  final ShopUsecases _shopUsecases;
  final Ref ref;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLastPage = false;

  ShopController(this._shopUsecases, this.ref) : super(const ShopStates()) {
    refreshShop(null);
  }

  Future<void> refreshShop(ShopEntity? criteria) async {
    await searchShop(criteria);
  }

  // --- RÉCUPÉRATION / RECHERCHE ---
  Future<void> searchShop(ShopEntity? criteria) async {
    final action = SearchShopAction(criteria?.id ?? "tous");
    _currentPage = 0;
    _isLastPage = false;

    _setLoadingState(action: action);

    state = state.copyWith(
      currentCriteria: criteria,
      shops: [],
      isLoading: true,
      action: action,
    );

    final res = await _shopUsecases.searchShop(
      criteria: criteria,
      start: 0,
      end: _pageSize - 1,
    );

    res.fold((error) => _setError(error: error, action: action), (success) {
      if (success.length < _pageSize) _isLastPage = true;
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        shops: success,
        currentCriteria: criteria,
        action: action,
      );
    });
  }

  // --- LAZY LOADING (PAGINATION) ---
  Future<void> loadNextPage() async {
    if (state.isLoading || _isLastPage) return;

    final action = GetShopAction();
    _currentPage++;
    final int start = _currentPage * _pageSize;
    final int end = start + _pageSize - 1;

    final res = await _shopUsecases.searchShop(
      criteria: state.currentCriteria,
      start: start,
      end: end,
    );

    res.fold(
      (error) {
        _currentPage--; // Backtrack sur l'erreur
        _setError(error: error, action: action);
      },
      (newshops) {
        if (newshops.isEmpty) {
          _isLastPage = true;
        } else {
          if (newshops.length < _pageSize) _isLastPage = true;
          state = state.copyWith(
            isLoading: false,
            shops: [...?state.shops, ...newshops],
            action: action,
          );
        }
      },
    );
  }

  // --- INSERTION ---
  Future<void> createShop(ShopEntity entity, File file, String? userId) async {
    final action = CreateShopAction(entity.id ?? entity.shopName!);
    _setLoadingState(action: action);

    final res = await _shopUsecases.insertShop(entity, file, userId!);

    res.fold((error) => _setError(error: error, action: action), (success) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        shops: [success, ...?state.shops],
        action: action,
      );
    });
  }

  // --- MISE À JOUR ---
  Future<void> updateShop(ShopEntity entity) async {
    final action = UpdateShopAction(entity.id ?? "inconnu");
    _setLoadingState(action: action);

    final res = await _shopUsecases.updateShop(entity);

    res.fold((error) => _setError(error: error, action: action), (
      updatedEntity,
    ) {
      final newList =
          state.shops?.map((item) {
            return item.id == updatedEntity.id ? updatedEntity : item;
          }).toList();

      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        shops: newList,
        action: action,
      );
    });
  }

  // --- SUPPRESSION ---
  Future<void> deleteShopById(String id) async {
    final action = DeleteShopAction(id);
    _setLoadingState(action: action);

    final res = await _shopUsecases.deleteShopById(id);

    res.fold((error) => _setError(error: error, action: action), (_) {
      final newList = state.shops?.where((i) => i.id != id).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        shops: newList,
        action: action,
      );
    });
  }

  // --- UTILITAIRES INTERNES ---
  void _setLoadingState({required ShopActions action}) {
    state = state.copyWith(isLoading: true, action: action);
  }

  void _setError({required Failure error, required ShopActions action}) {
    state = state.copyWith(
      isLoading: false,
      error: error,
      errorCode: error.code,
      action: action,
    );
  }
}

// --- PROVIDER ---
final shopControllerProvider =
    StateNotifierProvider<ShopController, ShopStates>((ref) {
      return ShopController(sl<ShopUsecases>(), ref);
    });
