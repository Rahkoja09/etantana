import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/features/stockPrediction/presentation/pages/stock_prediction_list.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StockPrediction extends ConsumerWidget {
  const StockPrediction({super.key});

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: Text(
              "Prédiction de stock",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            content: Text(
              "Cette section prédit quand vos produits risquent de se retrouver en rupture de stock, en se basant sur vos ventes hebdomadaires et votre stock actuel.",
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.6,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Compris",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockPredictionControllerProvider);
    final isLoading = state.isLoading;
    final predictions = state.predictions ?? [];

    return Skeletonizer(
      enabled: isLoading,
      effect: LoadingEffect.getCommonEffect(context),
      ignoreContainers: true,
      justifyMultiLineText: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MediumTitleWithDegree(
                showDegree: false,
                title: "Prédiction de stock",
              ),
              Row(
                children: [
                  // Badge nombre de produits à risque
                  if (!isLoading && predictions.isNotEmpty)
                    _buildRiskBadge(context, predictions),
                  SizedBox(width: 8.w),
                  // Bouton info
                  GestureDetector(
                    onTap: () => _showInfoDialog(context),
                    child: Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Icon(
                        Icons.question_mark_rounded,
                        size: 11.sp,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Liste
          StockPredictionList(),
        ],
      ),
    );
  }

  Widget _buildRiskBadge(BuildContext context, List predictions) {
    final criticalCount =
        predictions.where((p) => p.stockPressure > 0.8).length;
    final warningCount =
        predictions
            .where((p) => p.stockPressure > 0.5 && p.stockPressure <= 0.8)
            .length;

    if (criticalCount == 0 && warningCount == 0) return const SizedBox.shrink();

    final count = criticalCount > 0 ? criticalCount : warningCount;
    final color =
        criticalCount > 0 ? const Color(0xFFEF4444) : const Color(0xFFF97316);
    final label = criticalCount > 0 ? "critique" : "attention";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "$count $label${count > 1 ? 's' : ''}",
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
