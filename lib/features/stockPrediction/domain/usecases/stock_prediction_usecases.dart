import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/repository/order_repository.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';
import 'package:e_tantana/features/stockPrediction/domain/entity/stock_prediction_entity.dart';

class StockPredictionUsecases {
  final ProductRepository _productRepository;
  final OrderRepository _orderRepository;

  static const int _criticalWeeks = 1;
  static const int _warningWeeks = 4;
  static const int _safeWeeks = 8;

  static const int _criticalDays = _criticalWeeks * 7;
  static const int _warningDays = _warningWeeks * 7;
  static const int _safeDays = _safeWeeks * 7;

  StockPredictionUsecases(this._productRepository, this._orderRepository);

  ResultFuture<List<StockPredictionEntity>> getStockPrediction() async {
    final productsResult = await _productRepository.researchProduct(
      const ProductEntities(),
      start: 0,
      end: 100,
    );

    return productsResult.fold((failure) => Left(failure), (products) async {
      final ordersResult = await _orderRepository.researchOrder(
        const OrderEntities(),
        start: 0,
        end: 1000,
      );

      return ordersResult.fold((failure) => Left(failure), (orders) {
        final List<StockPredictionEntity> predictions = [];

        final now = DateTime.now();
        const windowDays = 7;
        final calculationLimit = now.subtract(const Duration(days: windowDays));

        final recentOrders =
            orders
                .where(
                  (o) =>
                      o.createdAt != null &&
                      o.createdAt!.isAfter(calculationLimit),
                )
                .toList();

        for (var product in products) {
          if (product.id == null) continue;

          int totalSold = 0;
          for (var order in recentOrders) {
            final items = order.productsAndQuantities;
            if (items != null) {
              for (var item in items) {
                if (item['id'] == product.id) {
                  totalSold += (item['quantity'] as num).toInt();
                }
              }
            }
          }

          final double dailyVelocity = totalSold / windowDays;
          final double salesPerWeek = dailyVelocity * 7;
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
              salesPerWeek: salesPerWeek,
              currentStock: currentStock,
              daysRemaining: daysRemaining,
              stockPressure: stockPressure.clamp(0.0, 1.0),
            ),
          );
        }

        return Right(predictions);
      });
    });
  }

  double _calculatePressure(int daysRemaining) {
    if (daysRemaining <= _criticalDays) {
      return 1.0;
    } else if (daysRemaining <= _warningDays) {
      final ratio =
          (daysRemaining - _criticalDays) / (_warningDays - _criticalDays);
      return 1.0 - (ratio * 0.6);
    } else if (daysRemaining <= _safeDays) {
      final ratio = (daysRemaining - _warningDays) / (_safeDays - _warningDays);
      return 0.4 - (ratio * 0.4);
    } else {
      return 0.0;
    }
  }
}
