import 'package:e_tantana/features/stockPrediction/presentation/widgets/prediction_header.dart';
import 'package:e_tantana/features/stockPrediction/presentation/widgets/prediction_progress_bar.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.grey[100],
            ),
            child: ImageViewer(imageFileOrLink: imagePath, borderRadius: 10),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PredictionHeader(name: productName, daysLeft: daysRemaining),
                const SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSmallStat(
                      "${salesPerWeek.toStringAsFixed(1)}u/sem",
                      "",
                    ),
                    _buildSmallStat("${currentStock}u en stock", ""),
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
    return Text(
      label,
      style: const TextStyle(fontSize: 10, color: Colors.grey),
    );
  }
}
