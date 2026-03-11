import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/feedback/domain/entity/feedback_entity.dart';

abstract class FeedbackRepository {
  /// Insère un nouveau Feedback
  ResultFuture<FeedbackEntity> insertFeedback(FeedbackEntity entity);

  /// Met à jour un Feedback existant
  ResultFuture<FeedbackEntity> updateFeedback(FeedbackEntity entity);

  /// Recherche des Feedbacks selon des critères avec pagination
  ResultFuture<List<FeedbackEntity>> searchFeedback({
    FeedbackEntity? criteria,
    int start = 0,
    int end = 9,
  });

  /// Récupère un Feedback spécifique par son ID
  ResultFuture<FeedbackEntity> getFeedbackById(String id);

  /// Supprime un Feedback définitivement
  ResultVoid deleteFeedbackById(String id);
}