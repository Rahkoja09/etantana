import 'package:equatable/equatable.dart';

class DashboardStatsEntities extends Equatable {
  final int? totalOrders;
  final int? deliveryToday;
  final double? revenue;
  final String? revenueIncrease;
  final String? period;

  const DashboardStatsEntities({
    this.totalOrders,
    this.deliveryToday,
    this.revenue,
    this.revenueIncrease,
    this.period,
  });

  @override
  List<Object?> get props => [
    totalOrders,
    deliveryToday,
    revenue,
    revenueIncrease,
    period,
  ];
}
