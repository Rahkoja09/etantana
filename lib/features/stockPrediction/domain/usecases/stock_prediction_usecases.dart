import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/repository/order_repository.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';
import 'package:e_tantana/features/stockPrediction/domain/entity/stock_prediction_entity.dart';
import 'package:e_tantana/features/stockPrediction/presentation/settings/stock_prediction_settings.dart';

class StockPredictionUsecases {
  final ProductRepository _productRepository;
  final OrderRepository _orderRepository;

  static const int _criticalDays = 7;
  static const int _warningDays = 28;
  static const int _safeDays = 56;

  StockPredictionUsecases(this._productRepository, this._orderRepository);

  /// [previewCount] null = tout afficher (page dédiée)
  /// [previewCount] int = top N produits commandés (home)
  ResultFuture<List<StockPredictionEntity>> getStockPrediction({
    StockPredictionSettings settings = const StockPredictionSettings(),
    int? previewCount,
  }) async {
    final productsResult = await _productRepository.researchProduct(
      const ProductEntities(),
      start: 0,
      end: 1000,
    );

    return productsResult.fold((failure) => Left(failure), (products) async {
      final ordersResult = await _orderRepository.researchOrder(
        const OrderEntities(),
        start: 0,
        end: 10000,
      );

      return ordersResult.fold((failure) => Left(failure), (orders) {
        final now = DateTime.now();
        final windowDays = settings.window.days;
        final calculationLimit = now.subtract(Duration(days: windowDays));

        final recentOrders =
            orders
                .where(
                  (o) =>
                      o.createdAt != null &&
                      o.createdAt!.isAfter(calculationLimit),
                )
                .toList();

        // Compter les ventes par produit dans la fenêtre
        final Map<String, int> salesPerProduct = {};
        for (var order in recentOrders) {
          final items = order.productsAndQuantities;
          if (items != null) {
            for (var item in items) {
              final id = item['id'] as String?;
              if (id != null) {
                salesPerProduct[id] =
                    (salesPerProduct[id] ?? 0) +
                    (item['quantity'] as num).toInt();
              }
            }
          }
        }

        final orderedProductIds = salesPerProduct.keys.toSet();
        final List<StockPredictionEntity> predictions = [];

        for (var product in products) {
          if (product.id == null) continue;

          // Home : uniquement les produits commandés
          // Page dédiée : tous les produits
          if (previewCount != null && !orderedProductIds.contains(product.id)) {
            continue;
          }

          final int totalSold = salesPerProduct[product.id] ?? 0;
          final double dailyVelocity = totalSold / windowDays;
          final double salesPerWindow = dailyVelocity * windowDays;
          final int currentStock = product.quantity ?? 0;

          int daysRemaining;
          double stockPressure;

          if (dailyVelocity > 0) {
            daysRemaining = (currentStock / dailyVelocity).floor();
            stockPressure = _calculatePressure(daysRemaining);
          } else {
            daysRemaining = 999;
            stockPressure = 0.0;
          }

          predictions.add(
            StockPredictionEntity(
              productId: product.id!,
              salesPerWeek: salesPerWindow,
              currentStock: currentStock,
              daysRemaining: daysRemaining,
              stockPressure: stockPressure.clamp(0.0, 1.0),
            ),
          );
        }

        // Trier par ventes décroissantes
        predictions.sort((a, b) => b.salesPerWeek.compareTo(a.salesPerWeek));

        // Limiter si preview home
        final result =
            previewCount != null
                ? predictions.take(previewCount).toList()
                : predictions;

        return Right(result);
      });
    });
  }

  double _calculatePressure(int daysRemaining) {
    if (daysRemaining <= _criticalDays) return 1.0;
    if (daysRemaining <= _warningDays) {
      final ratio =
          (daysRemaining - _criticalDays) / (_warningDays - _criticalDays);
      return 1.0 - (ratio * 0.6);
    }
    if (daysRemaining <= _safeDays) {
      final ratio = (daysRemaining - _warningDays) / (_safeDays - _warningDays);
      return 0.4 - (ratio * 0.4);
    }
    return 0.0;
  }
}
