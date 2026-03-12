import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/stockPrediction/domain/actions/stock_prediction_actions.dart';
import 'package:e_tantana/features/stockPrediction/domain/entity/stock_prediction_entity.dart';
import 'package:equatable/equatable.dart';

class StockPredictionState extends Equatable {
  final bool isHomeLoading;
  final bool isFullLoading;
  final Failure? error;
  final String? errorCode;
  final List<StockPredictionEntity>? predictions;
  final List<StockPredictionEntity>? predictionListForHome;
  final StockPredictionActions? action;

  const StockPredictionState({
    this.isHomeLoading = false,
    this.isFullLoading = false,
    this.error,
    this.predictions,
    this.action,
    this.errorCode,
    this.predictionListForHome,
  });

  bool get isLoading => isHomeLoading || isFullLoading;

  StockPredictionState copyWith({
    bool? isHomeLoading,
    bool? isFullLoading,
    bool? isLoading,
    Failure? error,
    List<StockPredictionEntity>? predictions,
    String? errorCode,
    StockPredictionActions? action,
    bool isClearError = false,
    List<StockPredictionEntity>? predictionListForHome,
  }) {
    return StockPredictionState(
      isHomeLoading: isHomeLoading ?? this.isHomeLoading,
      isFullLoading: isFullLoading ?? this.isFullLoading,
      error: isClearError == true ? null : (error ?? this.error),
      predictions: predictions ?? this.predictions,
      action: action ?? this.action,
      errorCode: errorCode ?? this.errorCode,
      predictionListForHome:
          predictionListForHome ?? this.predictionListForHome,
    );
  }

  @override
  List<Object?> get props => [
    isHomeLoading,
    isFullLoading,
    error,
    predictions,
    errorCode,
    action,
    predictionListForHome,
  ];
}
