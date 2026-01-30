import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/home/domain/entities/dashboard_stats_entities.dart';
import 'package:e_tantana/features/home/domain/repository/dashboard_stats_repository.dart';

class DashboardStatsUsecase {
  final DashboardStatsRepository _repository;
  DashboardStatsUsecase(this._repository);
  ResultFuture<DashboardStatsEntities> getDashboardStats() =>
      _repository.getDashboardStats();
}
