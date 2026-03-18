import 'package:e_tantana/core/app/session/session_controller.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/auth/presentation/states/auth_states.dart';
import 'package:e_tantana/features/delivring/presentation/controller/delivering_controller.dart';
import 'package:e_tantana/features/home/presentation/controller/dashboard_controller.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/shop/presentation/controller/shop_controller.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/features/user/presentation/controller/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppInitializer {
  final Ref ref;
  AppInitializer(this.ref);

  Future<void> initialize() async {
    await ref.read(authControllerProvider.notifier).checkAuthStatus();
    final status = ref.read(authControllerProvider).status;
    if (status != AuthStatus.authenticated) return;

    await Future.wait([
      ref.read(userControllerProvider.notifier).searchUser(null),
      ref.read(shopControllerProvider.notifier).searchShop(null),
    ]);

    await ref.read(sessionProvider.notifier).init();

    await Future.wait([
      ref.read(dashboardStatsControllerProvider.notifier).getDashboardStats(),
      ref.read(productControllerProvider.notifier).researchProduct(null),
      ref.read(orderControllerProvider.notifier).researchOrder(null),
      ref.read(deliveringControllerProvider.notifier).searchDelivering(null),
      ref.read(stockPredictionControllerProvider.notifier).refreshFull(),
    ]);
  }
}

final appInitializerProvider = Provider<AppInitializer>((ref) {
  return AppInitializer(ref);
});
