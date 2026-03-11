import 'package:equatable/equatable.dart';

class FeedbackEntity extends Equatable {
  final String? id;
  final DateTime? createdAt;
  final String? user_id;
  final int? rates;
  final String? comment;
  final List<String>? categoryOfFeedback;
  // [FIELDS_ANCHOR]

  const FeedbackEntity({
    this.id,
    this.createdAt,
    this.user_id,
    this.rates,
    this.comment,
    this.categoryOfFeedback,
    // [CONSTRUCTOR_ANCHOR]
  });

  FeedbackEntity copyWith({
    String? id,
    DateTime? createdAt,
    String? user_id,
    int? rates,
    String? comment,
    List<String>? categoryOfFeedback,
    // [COPYWITH_PARAMS_ANCHOR]
  }) {
    return FeedbackEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      user_id: user_id ?? this.user_id,
      rates: rates ?? this.rates,
      comment: comment ?? this.comment,
      categoryOfFeedback: categoryOfFeedback ?? this.categoryOfFeedback,
      // [COPYWITH_RETURN_ANCHOR]
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    user_id,
    rates,
    comment,
    categoryOfFeedback,
    // [PROPS_ANCHOR]
  ];
}
