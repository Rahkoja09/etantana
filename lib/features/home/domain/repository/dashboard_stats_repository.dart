import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/home/domain/entities/dashboard_stats_entities.dart';

abstract class DashboardStatsRepository {
  ResultFuture<DashboardStatsEntities> getDashboardStats();
}
