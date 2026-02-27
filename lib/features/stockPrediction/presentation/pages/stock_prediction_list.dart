import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/stockPrediction/domain/entity/stock_prediction_entity.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/features/stockPrediction/presentation/widgets/stock_prediction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<StockPredictionEntity> _fakePredictions = List.generate(
  5,
  (index) => StockPredictionEntity(
    productId: 'fake_$index',
    salesPerWeek: 0.0,
    currentStock: 0,
    daysRemaining: 0,
    stockPressure: 0.5,
  ),
);

class StockPredictionList extends ConsumerWidget {
  const StockPredictionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockPredictionControllerProvider);
    final products = ref.watch(productControllerProvider).product;

    final bool isLoading = state.isLoading;
    final predictionsToShow =
        isLoading ? _fakePredictions : (state.predictions ?? []);

    if (!isLoading && predictionsToShow.isEmpty) {
      return const Center(
        child: Text("Aucune donnée de prédiction disponible."),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: predictionsToShow.length,
      itemBuilder: (context, index) {
        final prediction = predictionsToShow[index];

        final product = products?.cast<ProductEntities?>().firstWhere(
          (p) => p?.id == prediction.productId,
          orElse: () => null,
        );
        print(prediction);

        return StockPredictionCard(
          imagePath:
              isLoading
                  ? AppConst.defaultImage
                  : (product?.images ?? AppConst.defaultImage),
          productName:
              isLoading
                  ? "Nom du produit factice"
                  : (product?.name ?? "Inconnu"),
          salesPerWeek: prediction.salesPerWeek,
          currentStock: prediction.currentStock,
          daysRemaining: prediction.daysRemaining,
          pressure: prediction.stockPressure,
        );
      },
    );
  }
}
