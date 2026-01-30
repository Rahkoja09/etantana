import 'package:e_tantana/features/home/data/model/dashboard_stats_model.dart';

abstract class DashboardStatsDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}
