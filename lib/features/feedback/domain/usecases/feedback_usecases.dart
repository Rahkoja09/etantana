import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/feedback/domain/entity/feedback_entity.dart';
import 'package:e_tantana/features/feedback/domain/repository/feedback_repository.dart';

class FeedbackUsecases {
  final FeedbackRepository _repo;

  FeedbackUsecases(this._repo);

  /// Exécute l'insertion d'un nouveau Feedback
  ResultFuture<FeedbackEntity> insertFeedback(FeedbackEntity entity) async {
    return await _repo.insertFeedback(entity);
  }

  /// Exécute la mise à jour d'un Feedback
  ResultFuture<FeedbackEntity> updateFeedback(FeedbackEntity entity) async {
    return await _repo.updateFeedback(entity);
  }

  /// Exécute la suppression d'un Feedback par son identifiant
  ResultVoid deleteFeedbackById(String id) async {
    return await _repo.deleteFeedbackById(id);
  }

  /// Récupère un Feedback spécifique
  ResultFuture<FeedbackEntity> getFeedbackById(String id) async {
    return await _repo.getFeedbackById(id);
  }

  /// Effectue une recherche de Feedback avec pagination
  ResultFuture<List<FeedbackEntity>> searchFeedback({
    FeedbackEntity? criteria,
    int start = 0,
    int end = 9,
  }) async {
    return await _repo.searchFeedback(
      criteria: criteria,
      start: start,
      end: end,
    );
  }
}
