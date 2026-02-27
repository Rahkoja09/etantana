import 'package:e_tantana/features/stockPrediction/presentation/widgets/prediction_header.dart';
import 'package:e_tantana/features/stockPrediction/presentation/widgets/prediction_progress_bar.dart';
import 'package:flutter/material.dart';

class StockPredictionCard extends StatelessWidget {
  final String productName;
  final String? imagePath;
  final double salesPerWeek;
  final int currentStock;
  final int daysRemaining;
  final double pressure;

  const StockPredictionCard({
    super.key,
    required this.productName,
    this.imagePath,
    required this.salesPerWeek,
    required this.currentStock,
    required this.daysRemaining,
    required this.pressure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PredictionHeader(name: productName, daysLeft: daysRemaining),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSmallStat(
                      "Ventes/sem",
                      "${salesPerWeek.toStringAsFixed(1)}u",
                    ),
                    _buildSmallStat("En stock", "${currentStock}u"),
                  ],
                ),
                const SizedBox(height: 10),
                PredictionProgressBar(pressure: pressure),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
