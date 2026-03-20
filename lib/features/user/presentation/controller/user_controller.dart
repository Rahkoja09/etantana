import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/user/domain/actions/user_actions.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';
import 'package:e_tantana/features/user/domain/usecases/user_usecases.dart';
import 'package:e_tantana/features/user/presentation/states/user_states.dart';

class UserController extends StateNotifier<UserStates> {
  final UserUsecases _userUsecases;
  final Ref ref;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLastPage = false;

  UserController(this._userUsecases, this.ref) : super(const UserStates()) {
    searchUser(null);
  }

  // --- RÉCUPÉRATION / RECHERCHE ---
  Future<void> searchUser(UserEntity? criteria) async {
    final action = SearchUserAction(criteria?.id ?? "tous");
    _currentPage = 0;
    _isLastPage = false;

    _setLoadingState(action: action);

    state = state.copyWith(
      currentCriteria: criteria,
      users: [],
      isLoading: true,
      action: action,
    );

    final res = await _userUsecases.searchUser(
      criteria: criteria,
      start: 0,
      end: _pageSize - 1,
    );

    res.fold((error) => _setError(error: error, action: action), (success) {
      if (success.length < _pageSize) _isLastPage = true;
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        users: success,
        currentCriteria: criteria,
        action: action,
      );
    });
  }

  void reset() {
    state = const UserStates();
  }

  // --- LAZY LOADING (PAGINATION) ---
  Future<void> loadNextPage() async {
    if (state.isLoading || _isLastPage) return;

    final action = GetUserAction();
    _currentPage++;
    final int start = _currentPage * _pageSize;
    final int end = start + _pageSize - 1;

    final res = await _userUsecases.searchUser(
      criteria: state.currentCriteria,
      start: start,
      end: end,
    );

    res.fold(
      (error) {
        _currentPage--; // Backtrack sur l'erreur
        _setError(error: error, action: action);
      },
      (newusers) {
        if (newusers.isEmpty) {
          _isLastPage = true;
        } else {
          if (newusers.length < _pageSize) _isLastPage = true;
          state = state.copyWith(
            isLoading: false,
            users: [...?state.users, ...newusers],
            action: action,
          );
        }
      },
    );
  }

  // --- INSERTION ---
  Future<void> createUser(
    UserEntity entity,
    File profilFile,
    String authId,
  ) async {
    final action = CreateUserAction(entity.id ?? entity.name!);
    _setLoadingState(action: action);

    final res = await _userUsecases.insertUser(entity, profilFile, authId);

    res.fold((error) => _setError(error: error, action: action), (success) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        users: [success, ...?state.users],
        action: action,
      );
    });
  }

  // --- MISE À JOUR ---
  Future<void> updateUser(UserEntity entity) async {
    final action = UpdateUserAction(entity.id ?? "inconnu");
    _setLoadingState(action: action);

    final res = await _userUsecases.updateUser(entity);

    res.fold((error) => _setError(error: error, action: action), (
      updatedEntity,
    ) {
      final newList =
          state.users?.map((item) {
            return item.id == updatedEntity.id ? updatedEntity : item;
          }).toList();

      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        users: newList,
        action: action,
      );
    });
  }

  Future<void> switchShop(UserEntity entity, String shopName) async {
    final action = SwitchShopUserAction(shopName);
    _setLoadingState(action: action);

    final res = await _userUsecases.updateUser(entity);

    res.fold((error) => _setError(error: error, action: action), (
      updatedEntity,
    ) {
      final newList =
          state.users?.map((item) {
            return item.id == updatedEntity.id ? updatedEntity : item;
          }).toList();

      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        users: newList,
        action: action,
      );
    });
  }

  // --- SUPPRESSION ---
  Future<void> deleteUserById(String id) async {
    final action = DeleteUserAction(id);
    _setLoadingState(action: action);

    final res = await _userUsecases.deleteUserById(id);

    res.fold((error) => _setError(error: error, action: action), (_) {
      final newList = state.users?.where((i) => i.id != id).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        users: newList,
        action: action,
      );
    });
  }

  // --- UTILITAIRES INTERNES ---
  void _setLoadingState({required UserActions action}) {
    state = state.copyWith(isLoading: true, action: action);
  }

  void _setError({required Failure error, required UserActions action}) {
    state = state.copyWith(
      isLoading: false,
      error: error,
      errorCode: error.code,
      action: action,
    );
  }
}

// --- PROVIDER ---
final userControllerProvider =
    StateNotifierProvider<UserController, UserStates>((ref) {
      return UserController(sl<UserUsecases>(), ref);
    });
