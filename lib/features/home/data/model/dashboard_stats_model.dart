import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/home/domain/entities/dashboard_stats_entities.dart';

class DashboardStatsModel extends DashboardStatsEntities {
  const DashboardStatsModel({
    required super.period,
    required super.revenue,
    required super.revenueIncrease,
    required super.totalOrders,
    required super.totalProducts,
  });

  factory DashboardStatsModel.fromMap(MapData data) {
    return DashboardStatsModel(
      period: data['period'] as String? ?? "Aujourd'hui",
      revenue: (data['revenue'] as num?)?.toDouble() ?? 0.0,
      revenueIncrease: data['revenue_increase'] as String? ?? "0%",
      totalOrders: (data['total_orders'] as num?)?.toInt() ?? 0,
      totalProducts: (data['total_products'] as num?)?.toInt() ?? 0,
    );
  }

  MapData toMap() {
    return {
      'period': period,
      'revenue': revenue,
      'revenue_increase': revenueIncrease,
      'total_orders': totalOrders,
      'total_products': totalProducts,
    };
  }

  factory DashboardStatsModel.fromEntity(DashboardStatsEntities entity) {
    return DashboardStatsModel(
      period: entity.period,
      revenue: entity.revenue,
      revenueIncrease: entity.revenueIncrease,
      totalOrders: entity.totalOrders,
      totalProducts: entity.totalProducts,
    );
  }

  DashboardStatsModel copyWith({
    String? period,
    double? revenue,
    String? revenueIncrease,
    int? totalOrders,
    int? totalProducts,
  }) {
    return DashboardStatsModel(
      period: period ?? this.period,
      revenue: revenue ?? this.revenue,
      revenueIncrease: revenueIncrease ?? this.revenueIncrease,
      totalOrders: totalOrders ?? this.totalOrders,
      totalProducts: totalProducts ?? this.totalProducts,
    );
  }
}
