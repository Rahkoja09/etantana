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

  StockPredictionUsecases(this._productRepository, this._orderRepository);

  /// Récupère les prédictions pour tous les produits disponibles
  ResultFuture<List<StockPredictionEntity>> getStockPrediction() async {
    // 1. Récupérer tous les produits (on peut ajuster start/end si besoin)
    final productsResult = await _productRepository.researchProduct(
      const ProductEntities(),
      start: 0,
      end: 100,
    );

    return productsResult.fold((failure) => Left(failure), (products) async {
      // 2. Récupérer les commandes des 30 derniers jours
      // On initialise un critère vide pour tout récupérer
      final ordersResult = await _orderRepository.researchOrder(
        const OrderEntities(),
        start: 0,
        end: 1000, // On prend un large spectre de commandes récentes
      );

      return ordersResult.fold((failure) => Left(failure), (orders) {
        final List<StockPredictionEntity> predictions = [];
        final now = DateTime.now();
        final thirtyDaysAgo = now.subtract(const Duration(days: 30));

        // Filtrer uniquement les commandes des 30 derniers jours
        final recentOrders =
            orders
                .where(
                  (o) =>
                      o.createdAt != null &&
                      o.createdAt!.isAfter(thirtyDaysAgo),
                )
                .toList();

        for (var product in products) {
          if (product.id == null) continue;

          // 3. Calculer le total vendu pour ce produit précis
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

          // 4. Calculer les métriques
          // Vitesse journalière
          double dailyVelocity = totalSold / 30;

          // Ventes par semaine (pour l'UI)
          double salesPerWeek = dailyVelocity * 7;

          // Jours restants (si pas de vente, on met un chiffre élevé par défaut pour éviter l'infini)
          int currentStock = product.quantity ?? 0;
          int daysRemaining =
              dailyVelocity > 0 ? (currentStock / dailyVelocity).floor() : 999;

          // Calcul de la "Pression" (0.0 à 1.0)
          // 1.0 = Rupture imminente (moins de 5 jours)
          // 0.0 = Stock large (plus de 30 jours)
          double stockPressure = 0.0;
          if (daysRemaining <= 30) {
            stockPressure = 1.0 - (daysRemaining / 30);
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
}
