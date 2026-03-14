import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IncomeStat extends StatefulWidget {
  final String title;
  final String cycle;
  final IconData icon;
  final IconData? bigStyleIcon;
  final String value;
  final String moneySign;
  final String increasePercent;
  final Color? themeColor;

  /// Historique de revenu sur 7 jours (du plus ancien au plus récent)
  /// Si null ou vide → pas de chart
  final List<double>? revenueHistory;

  const IncomeStat({
    super.key,
    required this.title,
    required this.cycle,
    required this.icon,
    required this.value,
    required this.moneySign,
    required this.increasePercent,
    this.themeColor,
    this.bigStyleIcon,
    this.revenueHistory,
  });

  @override
  State<IncomeStat> createState() => _IncomeStatState();
}

class _IncomeStatState extends State<IncomeStat> {
  bool isVisible = false;

  bool get _hasChart =>
      widget.revenueHistory != null && widget.revenueHistory!.length >= 2;

  bool get _isPositive =>
      widget.increasePercent.startsWith('+') ||
      (!widget.increasePercent.startsWith('-'));

  Color get _increaseColor =>
      _isPositive ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return ClipRRect(
      borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      child: Stack(
        children: [
          Container(
            height: 115.h,
            padding: EdgeInsets.all(StylesConstants.spacerContent),
            decoration: BoxDecoration(
              color: widget.themeColor ?? primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Colonne gauche ─────────────────────────
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre + icône
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(
                                StylesConstants.borderRadius,
                              ),
                            ),
                            child: HugeIcon(
                              icon: widget.icon,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.title,
                            style: TextStyles.bodyMedium(
                              context: context,
                              color: onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),

                      // Valeur + toggle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isVisible ? widget.value : "xxx,xxx",
                                style: TextStyles.titleSmall(
                                  context: context,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onLongPress:
                                    () =>
                                        setState(() => isVisible = !isVisible),
                                child: Icon(
                                  isVisible
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  size: 16,
                                  color: onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.moneySign,
                            style: TextStyles.bodySmall(
                              context: context,
                              color: onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Colonne droite : cycle + variation + chart ──
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Cycle
                    Text(
                      widget.cycle,
                      style: TextStyles.bodyMedium(
                        context: context,
                        color: onSurface.withValues(alpha: 0.5),
                      ),
                    ),

                    // Chart + variation
                    if (_hasChart)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Mini chart
                          SizedBox(
                            width: 70.w,
                            height: 36.h,
                            child: _RevenueSparkline(
                              history: widget.revenueHistory!,
                              color: _increaseColor,
                            ),
                          ),
                          SizedBox(width: 6.w),

                          // Badge variation
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: _increaseColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isPositive
                                      ? Icons.arrow_upward_rounded
                                      : Icons.arrow_downward_rounded,
                                  size: 9,
                                  color: _increaseColor,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  widget.increasePercent,
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w700,
                                    color: _increaseColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      // Fallback si pas de chart
                      Text(
                        widget.increasePercent,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: _increaseColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Icône décorative en fond
          Positioned(
            bottom: -15,
            right: _hasChart ? null : -15,
            left: _hasChart ? -15 : null,
            child: Transform.rotate(
              angle: -0.25,
              child: Icon(
                widget.bigStyleIcon ?? Icons.account_balance_wallet_rounded,
                size: 80,
                color: onSurface.withValues(alpha: 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueSparkline extends StatelessWidget {
  final List<double> history;
  final Color color;

  const _RevenueSparkline({required this.history, required this.color});

  @override
  Widget build(BuildContext context) {
    final max = history.reduce((a, b) => a > b ? a : b);
    final safeMax = max == 0 ? 1.0 : max;

    final spots =
        history
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value / safeMax))
            .toList();

    return LineChart(
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
            curveSmoothness: 0.4,
            color: color,
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
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
      duration: const Duration(milliseconds: 400),
    );
  }
}
