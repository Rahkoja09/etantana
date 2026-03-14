import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/stockPrediction/domain/actions/stock_prediction_actions.dart';
import 'package:e_tantana/features/stockPrediction/domain/usecases/stock_prediction_usecases.dart';
import 'package:e_tantana/features/stockPrediction/presentation/settings/stock_prediction_settings.dart';
import 'package:e_tantana/features/stockPrediction/presentation/states/stock_prediction_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockPredictionController extends StateNotifier<StockPredictionState> {
  final StockPredictionUsecases _usecases;

  StockPredictionController(this._usecases)
    : super(const StockPredictionState()) {
    init();
  }

  // fetch les données important dès le debut -----
  Future<void> init() async {
    fetchStockPredictionsForHome();
    fetchStockPredictions();
  }

  // ---- HOME PREVIEW ----
  Future<void> fetchStockPredictionsForHome({
    int previewCount = 3,
    StockPredictionSettings settings = const StockPredictionSettings(),
  }) async {
    final action = getStockPredictionAction();
    state = state.copyWith(isHomeLoading: true, action: action);

    final res = await _usecases.getStockPrediction(
      previewCount: previewCount,
      settings: settings,
    );

    res.fold(
      (error) =>
          state = state.copyWith(
            isHomeLoading: false,
            isClearError: false,
            error: error,
            action: action,
            errorCode: error.code,
          ),
      (predictions) =>
          state = state.copyWith(
            isHomeLoading: false,
            isClearError: true,
            predictionListForHome: predictions,
            action: action,
          ),
    );
  }

  // ---- FULL LIST (page dédiée) ----
  Future<void> fetchStockPredictions({
    StockPredictionSettings settings = const StockPredictionSettings(),
  }) async {
    final action = getStockPredictionAction();
    state = state.copyWith(isFullLoading: true, action: action);

    final res = await _usecases.getStockPrediction(
      previewCount: null,
      settings: settings,
    );

    res.fold(
      (error) =>
          state = state.copyWith(
            isFullLoading: false,
            isClearError: false,
            error: error,
            action: action,
            errorCode: error.code,
          ),
      (predictions) =>
          state = state.copyWith(
            isFullLoading: false,
            isClearError: true,
            predictions: predictions,
            action: action,
          ),
    );
  }

  Future<void> refreshHome() => fetchStockPredictionsForHome();
  Future<void> refreshFull() => fetchStockPredictions();
}

// --- Provider ---
final stockPredictionControllerProvider =
    StateNotifierProvider<StockPredictionController, StockPredictionState>(
      (ref) => StockPredictionController(sl<StockPredictionUsecases>()),
    );
