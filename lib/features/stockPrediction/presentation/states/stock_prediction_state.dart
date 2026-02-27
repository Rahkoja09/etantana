import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/stockPrediction/domain/actions/stock_prediction_actions.dart';
import 'package:e_tantana/features/stockPrediction/domain/entity/stock_prediction_entity.dart';
import 'package:equatable/equatable.dart';

class StockPredictionState extends Equatable {
  final bool isLoading;
  final Failure? error;
  final String? errorCode;
  final List<StockPredictionEntity>? predictions;
  final StockPredictionActions? action;

  const StockPredictionState({
    this.isLoading = false,
    this.error,
    this.predictions,
    this.action,
    this.errorCode,
  });

  StockPredictionState copyWith({
    bool? isLoading,
    Failure? error,
    List<StockPredictionEntity>? predictions,
    String? errorCode,
    StockPredictionActions? action,
    bool isClearError = false,
  }) {
    return StockPredictionState(
      isLoading: isLoading ?? this.isLoading,
      error: isClearError == true ? null : (error ?? this.error),
      predictions: predictions ?? this.predictions,
      action: action ?? this.action,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [error, predictions, isLoading, errorCode, action];
}
