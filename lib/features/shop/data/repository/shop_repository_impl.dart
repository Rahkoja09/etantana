import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/shop/data/source/shop_remote_source.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:e_tantana/features/shop/domain/repository/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteSource _remoteSource;
  final NetworkInfo _networkInfo;

  ShopRepositoryImpl(this._remoteSource, this._networkInfo);

  @override
  ResultFuture<ShopEntity> insertShop(ShopEntity entity) async {
    return await _executeAction(() => _remoteSource.insertShop(entity));
  }

  @override
  ResultFuture<ShopEntity> updateShop(ShopEntity entity) async {
    return await _executeAction(() => _remoteSource.updateShop(entity));
  }

  @override
  ResultFuture<List<ShopEntity>> searchShop({
    ShopEntity? criteria,
    int start = 0,
    int end = 9,
  }) async {
    return await _executeAction(() => _remoteSource.searchShop(criteria, start: start, end: end));
  }

  @override
  ResultFuture<ShopEntity> getShopById(String id) async {
    return await _executeAction(() => _remoteSource.getShopById(id));
  }

  @override
  ResultVoid deleteShopById(String id) async {
    return await _executeAction(() => _remoteSource.deleteShopById(id));
  }

  /// Helper générique pour gérer la connectivité et les erreurs
  Future<Either<Failure, T>> _executeAction<T>(Future<T> Function() action) async {
    if (await _networkInfo.isConnected) {
      try {
        final res = await action();
        return Right(res);
      } on ApiException catch (e) {
        return Left(ApiFailure.fromException(e));
      } catch (e) {
        return Left(UnexceptedFailure(e.toString(), "500"));
      }
    }
    return const Left(NetworkFailure("Pas de connexion Internet", "NET_001"));
  }
}