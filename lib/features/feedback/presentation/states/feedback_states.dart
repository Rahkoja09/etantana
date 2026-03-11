import 'package:equatable/equatable.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/feedback/domain/entity/feedback_entity.dart';
import 'package:e_tantana/features/feedback/domain/actions/feedback_actions.dart';

class FeedbackStates extends Equatable {
  final bool isLoading;
  final Failure? error;
  final List<FeedbackEntity>? feedbacks;
  final FeedbackEntity? currentCriteria;
  final FeedbackActions? action;
  final String? errorCode;

  const FeedbackStates({
    this.isLoading = false,
    this.error,
    this.feedbacks,
    this.currentCriteria,
    this.action,
    this.errorCode,
  });

  FeedbackStates copyWith({
    bool? isLoading,
    List<FeedbackEntity>? feedbacks,
    FeedbackEntity? currentCriteria,
    FeedbackActions? action,
    String? errorCode,
    Failure? error,
    bool isClearError = false,
  }) {
    return FeedbackStates(
      isLoading: isLoading ?? this.isLoading,
      error: isClearError == true ? null : (error ?? this.error),
      feedbacks: feedbacks ?? this.feedbacks,
      currentCriteria: currentCriteria ?? this.currentCriteria,
      action: action ?? this.action,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    feedbacks,
    currentCriteria,
    action,
    errorCode,
  ];
}
