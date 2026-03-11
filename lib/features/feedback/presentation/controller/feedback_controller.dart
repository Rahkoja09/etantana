import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/feedback/domain/actions/feedback_actions.dart';
import 'package:e_tantana/features/feedback/domain/entity/feedback_entity.dart';
import 'package:e_tantana/features/feedback/domain/usecases/feedback_usecases.dart';
import 'package:e_tantana/features/feedback/presentation/states/feedback_states.dart';

class FeedbackController extends StateNotifier<FeedbackStates> {
  final FeedbackUsecases _feedbackUsecases;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLastPage = false;

  FeedbackController(this._feedbackUsecases) : super(const FeedbackStates());

  // --- RÉCUPÉRATION / RECHERCHE ---
  Future<void> searchFeedback(FeedbackEntity? criteria) async {
    final action = SearchFeedbackAction(criteria?.id ?? "tous");
    _currentPage = 0;
    _isLastPage = false;

    _setLoadingState(action: action);
    
    state = state.copyWith(
      currentCriteria: criteria,
      feedbacks: [],
      isLoading: true,
      action: action,
    );

    final res = await _feedbackUsecases.searchFeedback(
      criteria: criteria,
      start: 0,
      end: _pageSize - 1,
    );

    res.fold(
      (error) => _setError(error: error, action: action),
      (success) {
        if (success.length < _pageSize) _isLastPage = true;
        state = state.copyWith(
          isLoading: false,
          isClearError: true,
          feedbacks: success,
          currentCriteria: criteria,
          action: action,
        );
      },
    );
  }

  // --- LAZY LOADING (PAGINATION) ---
  Future<void> loadNextPage() async {
    if (state.isLoading || _isLastPage) return;

    final action = GetFeedbackAction(); 
    _currentPage++;
    final int start = _currentPage * _pageSize;
    final int end = start + _pageSize - 1;

    final res = await _feedbackUsecases.searchFeedback(
      criteria: state.currentCriteria,
      start: start,
      end: end,
    );

    res.fold(
      (error) {
        _currentPage--; // Backtrack sur l'erreur
        _setError(error: error, action: action);
      },
      (newfeedbacks) {
        if (newfeedbacks.isEmpty) {
          _isLastPage = true;
        } else {
          if (newfeedbacks.length < _pageSize) _isLastPage = true;
          state = state.copyWith(
            isLoading: false,
            feedbacks: [...?state.feedbacks, ...newfeedbacks],
            action: action,
          );
        }
      },
    );
  }

  // --- INSERTION ---
  Future<void> createFeedback(FeedbackEntity entity) async {
    final action = CreateFeedbackAction(entity.id ?? "nouveau");
    _setLoadingState(action: action);

    final res = await _feedbackUsecases.insertFeedback(entity);

    res.fold(
      (error) => _setError(error: error, action: action),
      (success) {
        state = state.copyWith(
          isLoading: false,
          isClearError: true,
          feedbacks: [success, ...?state.feedbacks],
          action: action,
        );
      },
    );
  }

  // --- MISE À JOUR ---
  Future<void> updateFeedback(FeedbackEntity entity) async {
    final action = UpdateFeedbackAction(entity.id ?? "inconnu");
    _setLoadingState(action: action);

    final res = await _feedbackUsecases.updateFeedback(entity);

    res.fold(
      (error) => _setError(error: error, action: action),
      (updatedEntity) {
        final newList = state.feedbacks?.map((item) {
          return item.id == updatedEntity.id ? updatedEntity : item;
        }).toList();

        state = state.copyWith(
          isLoading: false,
          isClearError: true,
          feedbacks: newList,
          action: action,
        );
      },
    );
  }

  // --- SUPPRESSION ---
  Future<void> deleteFeedbackById(String id) async {
    final action = DeleteFeedbackAction(id);
    _setLoadingState(action: action);

    final res = await _feedbackUsecases.deleteFeedbackById(id);

    res.fold(
      (error) => _setError(error: error, action: action),
      (_) {
        final newList = state.feedbacks?.where((i) => i.id != id).toList() ?? [];
        state = state.copyWith(
          isLoading: false,
          isClearError: true,
          feedbacks: newList,
          action: action,
        );
      },
    );
  }

  // --- UTILITAIRES INTERNES ---
  void _setLoadingState({required FeedbackActions action}) {
    state = state.copyWith(isLoading: true, action: action);
  }

  void _setError({required Failure error, required FeedbackActions action}) {
    state = state.copyWith(
      isLoading: false,
      error: error,
      errorCode: error.code,
      action: action,
    );
  }
}

// --- PROVIDER ---
final feedbackControllerProvider =
    StateNotifierProvider<FeedbackController, FeedbackStates>((ref) {
  return FeedbackController(sl<FeedbackUsecases>());
});