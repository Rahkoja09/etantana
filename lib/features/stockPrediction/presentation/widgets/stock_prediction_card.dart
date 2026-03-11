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

  Color get _pressureColor {
    if (pressure > 0.8) return const Color(0xFFEF4444);
    if (pressure > 0.5) return const Color(0xFFF97316);
    return const Color(0xFF22C55E);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 48.r,
              height: 48.r,
              child: ImageViewer(imageFileOrLink: imagePath, borderRadius: 10),
            ),
          ),
          SizedBox(width: 12.w),

          // Nom + ventes
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  "${salesPerWeek.toStringAsFixed(0)} ventes / semaine",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
                SizedBox(height: 8.h),
                PredictionProgressBar(pressure: pressure),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Stock + jours
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$currentStock",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                "unités",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _pressureColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${daysRemaining}j",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: _pressureColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
