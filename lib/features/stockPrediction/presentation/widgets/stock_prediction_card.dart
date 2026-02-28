import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/stockPrediction/presentation/widgets/prediction_progress_bar.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      margin: EdgeInsets.only(bottom: StylesConstants.spacerContent),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: Row(
        children: [
          // Image produit
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ImageViewer(imageFileOrLink: imagePath, borderRadius: 12),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  "${salesPerWeek.toStringAsFixed(0)} ventes / semaine",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Stock + jours + barre
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    "${currentStock}u.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${daysRemaining}j",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 92.w,
                child: PredictionProgressBar(pressure: pressure),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
