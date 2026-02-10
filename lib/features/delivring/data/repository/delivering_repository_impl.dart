import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/delivring/data/source/delivering_remote_source.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';
import 'package:e_tantana/features/delivring/domain/repository/delivering_repository.dart';

class DeliveringRepositoryImpl implements DeliveringRepository {
  final DeliveringRemoteSource _remoteSource;
  final NetworkInfo _networkInfo;
  DeliveringRepositoryImpl(this._remoteSource, this._networkInfo);

  @override
  ResultVoid deleteDeliveringById(String id) async {
    return await _executeAction(() => _remoteSource.deleteDeliveringById(id));
  }

  @override
  ResultFuture<DeliveringEntity> insertDelivering(
    DeliveringEntity delivering,
  ) async {
    return await _executeAction(
      () => _remoteSource.insertDelivering(delivering),
    );
  }

  @override
  ResultFuture<List<DeliveringEntity>> searchDelivering(
    DeliveringEntity criteriales, {
    int start = 0,
    int end = 9,
  }) async {
    return await _executeAction(
      () => _remoteSource.searchDelivering(criteriales, start: start, end: end),
    );
  }

  @override
  ResultFuture<DeliveringEntity> selectDeliveringById(String id) async {
    return await _executeAction(() => _remoteSource.selectDeliveringById(id));
  }

  @override
  ResultFuture<DeliveringEntity> updateDeliveringByI(
    DeliveringEntity updates,
  ) async {
    return await _executeAction(
      () => _remoteSource.updateDeliveringById(updates),
    );
  }

  ResultFuture<T> _executeAction<T>(Future<T> Function() action) async {
    if (await _networkInfo.isConnected) {
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
