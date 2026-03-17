import 'package:e_tantana/core/providers/shop/active_shop_provider.dart';
import 'package:e_tantana/features/delivring/presentation/controller/delivering_controller.dart';
import 'package:e_tantana/features/home/presentation/controller/dashboard_controller.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopSwitchLoadingProvider = Provider<bool>((ref) {
  final products = ref.watch(productControllerProvider).isLoading;
  final orders = ref.watch(orderControllerProvider).isLoading;
  final delivering = ref.watch(deliveringControllerProvider).isLoading;
  final stockProdiction =
      ref.watch(stockPredictionControllerProvider).isLoading;
  final dashboard = ref.watch(dashboardStatsControllerProvider).isLoading;
  final isSwitching = ref.watch(activeShopIdProvider).isSwitching;
  if (!isSwitching) return false;

  return products || orders || delivering || stockProdiction || dashboard;
});
