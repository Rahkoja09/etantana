import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/app/session/session_controller.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/stockPrediction/domain/actions/stock_prediction_actions.dart';
import 'package:e_tantana/features/stockPrediction/domain/usecases/stock_prediction_usecases.dart';
import 'package:e_tantana/features/stockPrediction/presentation/settings/stock_prediction_settings.dart';
import 'package:e_tantana/features/stockPrediction/presentation/states/stock_prediction_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockPredictionController extends StateNotifier<StockPredictionState> {
  final StockPredictionUsecases _usecases;
  final Ref ref;

  StockPredictionController(this._usecases, this.ref)
    : super(const StockPredictionState()) {
    init();
  }

  // fetch les données important dès le debut -----
  Future<void> init() async {
    fetchStockPredictionsForHome();
    fetchStockPredictions();
  }

  void reset() {
    state = const StockPredictionState();
  }

  // ---- HOME PREVIEW ----
  Future<void> fetchStockPredictionsForHome({
    int previewCount = 3,
    StockPredictionSettings settings = const StockPredictionSettings(),
  }) async {
    final action = getStockPredictionAction();
    state = state.copyWith(isHomeLoading: true, action: action);

    final productCriteria = ProductEntities(
      shopId: ref.watch(sessionProvider).activeShopId,
    );
    final orderCriteria = OrderEntities(
      shopId: ref.watch(sessionProvider).activeShopId,
    );

    final res = await _usecases.getStockPrediction(
      productCriteria: productCriteria,
      orderCriteria: orderCriteria,
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

    final productCriteria = ProductEntities(
      shopId: ref.watch(sessionProvider).activeShopId,
    );
    final orderCriteria = OrderEntities(
      shopId: ref.watch(sessionProvider).activeShopId,
    );

    final res = await _usecases.getStockPrediction(
      productCriteria: productCriteria,
      orderCriteria: orderCriteria,
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
      (ref) => StockPredictionController(sl<StockPredictionUsecases>(), ref),
    );
