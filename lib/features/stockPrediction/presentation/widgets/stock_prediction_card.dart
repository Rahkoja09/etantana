import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StockPredictionCard extends StatelessWidget {
  final String productName;
  final String? imagePath;
  final double salesPerWeek;
  final int currentStock;
  final int daysRemaining;
  final double pressure;
  final List<double>? pressureHistory;

  const StockPredictionCard({
    super.key,
    required this.productName,
    this.imagePath,
    required this.salesPerWeek,
    required this.currentStock,
    required this.daysRemaining,
    required this.pressure,
    this.pressureHistory,
  });

  Color get _pressureColor {
    if (pressure > 0.8) return const Color(0xFFEF4444);
    if (pressure > 0.5) return const Color(0xFFF97316);
    return const Color(0xFF22C55E);
  }

  String get _pressureLabel {
    if (pressure > 0.8) return "Critique";
    if (pressure > 0.5) return "Attention";
    return "OK";
  }

  String get _daysLabel => daysRemaining >= 999 ? "∞" : "${daysRemaining}j";

  List<double> _buildHistory() {
    return List.generate(7, (i) {
      final ratio = i / 6.0;

      final simulated = pressure * (ratio * ratio);
      return simulated.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final history = _buildHistory();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 48.r,
                height: 48.r,
                child: ImageViewer(
                  imageFileOrLink: imagePath,
                  borderRadius: 10,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Nom + ventes + sparkline
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
                  SizedBox(height: 2.h),
                  Text(
                    "${salesPerWeek.toStringAsFixed(0)} ventes / sem.",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _PressureSparkline(
                    history: history,
                    color: _pressureColor,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),

            // Stock + badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$currentStock",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "unités",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _pressureColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: _pressureColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _daysLabel,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: _pressureColor,
                        ),
                      ),
                      Text(
                        _pressureLabel,
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: _pressureColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Sparkline ----
class _PressureSparkline extends StatelessWidget {
  final List<double> history;
  final Color color;
  final bool isDark;

  const _PressureSparkline({
    required this.history,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final spots =
        history
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value))
            .toList();

    return SizedBox(
      height: 32.h,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 1,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: color,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) => spot == barData.spots.last,
                getDotPainter:
                    (spot, percent, barData, index) => FlDotCirclePainter(
                      radius: 3,
                      color: color,
                      strokeWidth: 1.5,
                      strokeColor: isDark ? Colors.black : Colors.white,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.2),
                    color.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
