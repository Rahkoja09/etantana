import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/features/stockPrediction/presentation/widgets/stock_prediction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockPredictionList extends ConsumerWidget {
  const StockPredictionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockPredictionControllerProvider);
    final products = ref.watch(productControllerProvider).product;

    if (state.isLoading && (state.predictions?.isEmpty ?? true)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.predictions == null || state.predictions!.isEmpty) {
      return const Center(
        child: Text("Aucune donnée de prédiction disponible."),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.predictions!.length,
      itemBuilder: (context, index) {
        final prediction = state.predictions![index];
        final product = products?.firstWhere(
          (p) => p.id == prediction.productId,
          orElse: () => const ProductEntities(name: "Produit inconnu"),
        );

        return StockPredictionCard(
          productName: product?.name ?? "Inconnu",
          salesPerWeek: prediction.salesPerWeek,
          currentStock: prediction.currentStock,
          daysRemaining: prediction.daysRemaining,
          pressure: prediction.stockPressure,
        );
      },
    );
  }
}
