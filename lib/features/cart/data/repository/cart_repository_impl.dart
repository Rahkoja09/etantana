import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/cart/data/source/cart_remote_source.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:e_tantana/features/cart/domain/repository/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteSource _remoteSource;
  final NetworkInfo _networkInfo;

  CartRepositoryImpl(this._remoteSource, this._networkInfo);

  @override
  ResultFuture<CartEntity> insertCart(CartEntity entity) async {
    return await _executeAction(() => _remoteSource.insertCart(entity));
  }

  @override
  ResultFuture<CartEntity> updateCart(CartEntity entity) async {
    return await _executeAction(() => _remoteSource.updateCart(entity));
  }

  @override
  ResultFuture<List<CartEntity>> searchCart({
    CartEntity? criteria,
    int start = 0,
    int end = 9,
  }) async {
    return await _executeAction(() => _remoteSource.searchCart(criteria, start: start, end: end));
  }

  @override
  ResultFuture<CartEntity> getCartById(String id) async {
    return await _executeAction(() => _remoteSource.getCartById(id));
  }

  @override
  ResultVoid deleteCartById(String id) async {
    return await _executeAction(() => _remoteSource.deleteCartById(id));
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