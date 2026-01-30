import 'package:e_tantana/features/home/domain/entities/dashboard_stats_entities.dart';
import 'package:equatable/equatable.dart';

class DashboardStates extends Equatable {
  final bool isLoading;
  final DashboardStatsEntities? dashboard;
  final String? errorMessage;
  const DashboardStates({
    this.isLoading = false,
    this.dashboard,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, dashboard, errorMessage];

  DashboardStates copyWith({
    bool? isLoading,
    DashboardStatsEntities? dashboard,
    String? errorMessage,
    bool? isClearError = false,
  }) {
    return DashboardStates(
      isLoading: isLoading ?? this.isLoading,
      dashboard: dashboard ?? this.dashboard,
      errorMessage:
          isClearError == true ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
