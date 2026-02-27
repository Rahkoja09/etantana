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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(stockPredictionControllerProvider).isLoading;
    return Skeletonizer(
      enabled: isLoading,
      effect: LoadingEffect.getCommonEffect(context),
      ignoreContainers: true,
      justifyMultiLineText: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MediumTitleWithDegree(
                showDegree: false,
                title: "Prediction de stock",
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  child: Icon(
                    Icons.question_mark_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          StockPredictionList(),
        ],
      ),
    );
  }
}
