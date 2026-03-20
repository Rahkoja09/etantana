import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/app/session/session_controller.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';
import 'package:e_tantana/features/delivring/domain/usecases/delivering_usecases.dart';
import 'package:e_tantana/features/delivring/presentation/states/delivering_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveringController extends StateNotifier<DeliveringStates> {
  final DeliveringUsecases _usecases;
  final Ref ref;

  DeliveringController(this._usecases, this.ref) : super(DeliveringStates());

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLastPage = false;

  Future<void> addDelivering(DeliveringEntity entities) async {
    final action = deliveringAction.deliveringInsert;
    _setLoadingState(action: action);
    final res = await _usecases.insertDelivering(entities);
    res.fold((error) => _setError(error: error, action: action), (success) {
      state = state.copyWith(
        isLoading: false,
        deliverings: [success, ...?state.deliverings],
        action: action,
      );
    });
  }

  Future<void> updateDelivering(DeliveringEntity entities) async {
    final action = deliveringAction.deliveringUpdate;
    _setLoadingState(action: action);
    final res = await _usecases.updateDeliveringByI(entities);
    res.fold((error) => _setError(error: error, action: action), (
      updatedDelivering,
    ) {
      final newList =
          state.deliverings
              ?.map((p) => p.id == updatedDelivering.id ? updatedDelivering : p)
              .toList() ??
          [];
      state = state.copyWith(
        isLoading: false,
        deliverings: newList,
        action: action,
      );
    });
  }

  Future<void> deleteDeliveringById(String deliveringId) async {
    final action = deliveringAction.deliveringDelete;
    _setLoadingState(action: action);
    final res = await _usecases.deleteDeliveringById(deliveringId);
    res.fold((error) => _setError(error: error, action: action), (success) {
      final newList =
          state.deliverings?.where((p) => p.id != deliveringId).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        deliverings: newList,
        action: action,
      );
    });
  }

  Future<void> getDeliveringById(String deliveringId) async {
    final action = deliveringAction.deliveringSelect;
    _setLoadingState(action: action);
    final res = await _usecases.selectDeliveringById(deliveringId);

    res.fold((error) => _setError(error: error, action: action), (success) {
      final otherDeliverings =
          state.deliverings?.where((p) => p.id != success.id).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        deliverings: [success, ...otherDeliverings],
        action: action,
      );
    });
  }

  Future<void> searchDelivering(DeliveringEntity? criterial) async {
    final shopId = ref.read(sessionProvider).activeShopId;
    if (shopId != null && shopId != "" && criterial != null) {
      criterial = criterial.copyWith(shopId: shopId);
    } else if (criterial == null) {
      criterial = DeliveringEntity(shopId: shopId);
    }

    final action = deliveringAction.deliveringSearch;
    _currentPage = 0;
    _isLastPage = false;

    _setLoadingState(action: action);

    state = state.copyWith(
      currentCriteria: criterial,
      deliverings: [],
      isLoading: true,
      action: action,
    );

    final res = await _usecases.searchDelivering(
      criterial,
      start: 0,
      end: _pageSize - 1,
    );

    res.fold((error) => _setError(error: error, action: action), (success) {
      if (success.length < _pageSize) _isLastPage = true;
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        deliverings: success,
        action: action,
      );
    });
  }

  // page suivante du lazy loading ------
  Future<void> loadNextPage() async {
    final action = deliveringAction.deliveringLoadNextPage;
    if (state.isLoading || _isLastPage) return;

    _currentPage++;
    final int start = _currentPage * _pageSize;
    final int end = start + _pageSize - 1;

    final res = await _usecases.searchDelivering(
      state.currentCriteria!,
      start: start,
      end: end,
    );

    res.fold((error) => _setError(error: error, action: action), (
      newdeliverings,
    ) {
      if (newdeliverings.isEmpty) {
        _isLastPage = true;
      } else {
        if (newdeliverings.length < _pageSize) _isLastPage = true;

        state = state.copyWith(
          isLoading: false,
          deliverings: [...?state.deliverings, ...newdeliverings],
          action: action,
        );
      }
    });
  }

  void reset() {
    state = DeliveringStates();
  }

  void updateCriterial(DeliveringEntity updateCriterial) {
    state = state.copyWith(currentCriteria: updateCriterial);
  }

  void _setLoadingState({required deliveringAction action}) {
    state = state.copyWith(isLoading: true, action: action);
  }

  void _setError({required Failure error, required deliveringAction action}) {
    state = state.copyWith(
      isLoading: false,
      isClearError: false,
      error: error,
      action: action,
      errorCode: error.code,
    );
  }

  // Getters -------
  int get currentPage => _currentPage;
  bool get isLastPage => _isLastPage;
}

final deliveringControllerProvider =
    StateNotifierProvider<DeliveringController, DeliveringStates>((ref) {
      final deliveringUsecases = sl<DeliveringUsecases>();
      return DeliveringController(deliveringUsecases, ref);
    });
