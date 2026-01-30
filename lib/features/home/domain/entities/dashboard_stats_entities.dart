import 'package:equatable/equatable.dart';

class DashboardStatsEntities extends Equatable {
  final int? totalOrders;
  final int? totalProducts;
  final double? revenue;
  final String? revenueIncrease;
  final String? period;

  const DashboardStatsEntities({
    this.totalOrders,
    this.totalProducts,
    this.revenue,
    this.revenueIncrease,
    this.period,
  });

  @override
  List<Object?> get props => [
    totalOrders,
    totalProducts,
    revenue,
    revenueIncrease,
    period,
  ];
}
