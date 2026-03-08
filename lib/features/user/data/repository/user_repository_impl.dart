import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/user/data/source/user_remote_source.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';
import 'package:e_tantana/features/user/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteSource _remoteSource;
  final NetworkInfo _networkInfo;

  UserRepositoryImpl(this._remoteSource, this._networkInfo);

  @override
  ResultFuture<UserEntity> insertUser(UserEntity entity) async {
    return await _executeAction(() => _remoteSource.insertUser(entity));
  }

  @override
  ResultFuture<UserEntity> updateUser(UserEntity entity) async {
    return await _executeAction(() => _remoteSource.updateUser(entity));
  }

  @override
  ResultFuture<List<UserEntity>> searchUser({
    UserEntity? criteria,
    int start = 0,
    int end = 9,
  }) async {
    return await _executeAction(() => _remoteSource.searchUser(criteria, start: start, end: end));
  }

  @override
  ResultFuture<UserEntity> getUserById(String id) async {
    return await _executeAction(() => _remoteSource.getUserById(id));
  }

  @override
  ResultVoid deleteUserById(String id) async {
    return await _executeAction(() => _remoteSource.deleteUserById(id));
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