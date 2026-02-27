import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/stockPrediction/domain/actions/stock_prediction_actions.dart';
import 'package:e_tantana/features/stockPrediction/domain/usecases/stock_prediction_usecases.dart';
import 'package:e_tantana/features/stockPrediction/presentation/states/stock_prediction_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockPredictionController extends StateNotifier<StockPredictionState> {
  final StockPredictionUsecases _usecases;

  StockPredictionController(this._usecases)
    : super(const StockPredictionState()) {
    fetchStockPredictions();
  }

  Future<void> fetchStockPredictions() async {
    final action = getStockPredictionAction();
    _setLoadingState(action: action);

    final res = await _usecases.getStockPrediction();

    res.fold((error) => _setError(error: error, action: action), (predictions) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        predictions: predictions,
        action: action,
      );
    });
  }

  Future<void> refresh() async {
    await fetchStockPredictions();
  }

  void _setLoadingState({required dynamic action}) {
    state = state.copyWith(isLoading: true, action: action);
  }

  void _setError({required Failure error, required dynamic action}) {
    state = state.copyWith(
      isLoading: false,
      isClearError: false,
      error: error,
      action: action,
      errorCode: error.code,
    );
  }
}

// --- Provider ---

final stockPredictionControllerProvider =
    StateNotifierProvider<StockPredictionController, StockPredictionState>((
      ref,
    ) {
      final usecases = sl<StockPredictionUsecases>();
      return StockPredictionController(usecases);
    });
