import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/home/domain/usecases/dashboard_stats_usecase.dart';
import 'package:e_tantana/features/home/presentation/states/dashboard_states.dart';
import 'package:riverpod/riverpod.dart';

class DashboardController extends StateNotifier<DashboardStates> {
  final DashboardStatsUsecase _usecase;
  DashboardController(this._usecase) : super(DashboardStates());

  Future<void> getDashboardStats() async {
    _setLoadingState();
    final res = await _usecase.getDashboardStats();
    res.fold(
      (error) => _setError(error),
      (success) =>
          state = state.copyWith(
            isLoading: false,
            errorMessage: null,
            isClearError: true,
            dashboard: success,
          ),
    );
  }

  // set loading state ----------
  void _setLoadingState() {
    state = state.copyWith(isLoading: true);
  }

  void _setError(Failure error) {
    state = state.copyWith(
      isLoading: false,
      isClearError: false,
      errorMessage: error.message,
    );
  }
}

final dashboardStatsControllerProvider =
    StateNotifierProvider<DashboardController, DashboardStates>((ref) {
      final usecases = sl<DashboardStatsUsecase>();
      return DashboardController(usecases);
    });
