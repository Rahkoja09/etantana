import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/home/data/dataSrouce/dashboard_stats_data_source.dart';
import 'package:e_tantana/features/home/domain/entities/dashboard_stats_entities.dart';
import 'package:e_tantana/features/home/domain/repository/dashboard_stats_repository.dart';

class DashboardStatsRepositoryImpl implements DashboardStatsRepository {
  final DashboardStatsDataSource _dataSource;
  final NetworkInfo _networkInfo;
  DashboardStatsRepositoryImpl(this._dataSource, this._networkInfo);
  @override
  ResultFuture<DashboardStatsEntities> getDashboardStats() async {
    return await _executeAction<DashboardStatsEntities>(
      () => _dataSource.getDashboardStats(),
      isCritical: false,
    );
  }

  ResultFuture<T> _executeAction<T>(
    Future<T> Function() action, {
    bool isCritical = true,
  }) async {
    final bool connected =
        isCritical
            ? await _networkInfo.isConnected
            : await _networkInfo.hasConnection;

    if (connected) {
      try {
        final res = await action();
        return Right(res);
      } on ApiException catch (e) {
        return Left(ApiFailure.fromException(e));
      } on AuthUserException catch (e) {
        return Left(AuthFailure.fromException(e));
      } catch (e) {
        return Left(UnexceptedFailure(e.toString(), "000"));
      }
    }
    return const Left(
      NetworkFailure("Pas de connexion internet", "Network_01"),
    );
  }
}
