import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/app/network/network_info.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/feedback/data/source/feedback_remote_source.dart';
import 'package:e_tantana/features/feedback/domain/entity/feedback_entity.dart';
import 'package:e_tantana/features/feedback/domain/repository/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteSource _remoteSource;
  final NetworkInfo _networkInfo;

  FeedbackRepositoryImpl(this._remoteSource, this._networkInfo);

  @override
  ResultFuture<FeedbackEntity> insertFeedback(FeedbackEntity entity) async {
    return await _executeAction(() => _remoteSource.insertFeedback(entity));
  }

  @override
  ResultFuture<FeedbackEntity> updateFeedback(FeedbackEntity entity) async {
    return await _executeAction(() => _remoteSource.updateFeedback(entity));
  }

  @override
  ResultFuture<List<FeedbackEntity>> searchFeedback({
    FeedbackEntity? criteria,
    int start = 0,
    int end = 9,
  }) async {
    return await _executeAction(
      () => _remoteSource.searchFeedback(criteria, start: start, end: end),
    );
  }

  @override
  ResultFuture<FeedbackEntity> getFeedbackById(String id) async {
    return await _executeAction(() => _remoteSource.getFeedbackById(id));
  }

  @override
  ResultVoid deleteFeedbackById(String id) async {
    return await _executeAction(() => _remoteSource.deleteFeedbackById(id));
  }

  /// Helper générique pour gérer la connectivité et les erreurs
  Future<Either<Failure, T>> _executeAction<T>(
    Future<T> Function() action,
  ) async {
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
