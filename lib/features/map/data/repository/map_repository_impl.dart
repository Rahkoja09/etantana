import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/map/data/source/map_source_remote.dart';
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';
import 'package:e_tantana/features/map/domain/repository/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource _remote;
  final NetworkInfo _networkInfo;
  MapRepositoryImpl(this._remote, this._networkInfo);

  @override
  ResultFuture<MapEntity?> getCoordinatesFromAddress(String address) async {
    return await _executeAction(
      () => _remote.getCoordinatesFromAddress(address),
    );
  }

  Future<Either<Failure, T>> _executeAction<T>(
    Future<T> Function() action,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final res = await action();
        return Right(res);
      } on ServerException catch (e) {
        if (e.code.startsWith('5')) {
          return Left(ServerFailure.fromException(e));
        }
        return Left(ServerFailure.fromException(e));
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
