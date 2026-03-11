import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/feedback/domain/entity/feedback_entity.dart';

class FeedbackModel extends FeedbackEntity {
  FeedbackModel({
    super.id,
    super.createdAt,
        super.user_id,
    super.rates,
    super.comment,
    // [CONSTRUCTOR_ANCHOR]
  });

  factory FeedbackModel.fromMap(MapData data) {
    return FeedbackModel(
      id: data['id'] as String?,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
            user_id: data['user_id'] as String?,
      rates: data['rates'] as int?,
      comment: data['comment'] as String?,
      // [FROM_MAP_ANCHOR]
    );
  }

  MapData toMap() {
    return {
      if (id != null) 'id': id,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
            'user_id': user_id,
      'rates': rates,
      'comment': comment,
      // [TO_MAP_ANCHOR]
    };
  }

  factory FeedbackModel.fromEntity(FeedbackEntity entity) {
    return FeedbackModel(
      id: entity.id,
      createdAt: entity.createdAt,
            user_id: entity.user_id,
      rates: entity.rates,
      comment: entity.comment,
      // [FROM_ENTITY_ANCHOR]
    );
  }
}