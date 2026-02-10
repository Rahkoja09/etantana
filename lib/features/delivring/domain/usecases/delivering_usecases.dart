import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';
import 'package:e_tantana/features/delivring/domain/repository/delivering_repository.dart';

class DeliveringUsecases {
  final DeliveringRepository _repo;
  DeliveringUsecases(this._repo);
  ResultFuture<DeliveringEntity> insertDelivering(
    DeliveringEntity delivering,
  ) async {
    return await _repo.insertDelivering(delivering);
  }

  ResultFuture<DeliveringEntity> updateDeliveringByI(
    DeliveringEntity updates,
  ) async {
    return await _repo.updateDeliveringByI(updates);
  }

  ResultVoid deleteDeliveringById(String id) async {
    return await _repo.deleteDeliveringById(id);
  }

  ResultFuture<List<DeliveringEntity>> searchDelivering(
    DeliveringEntity criteriales, {
    int start = 0,
    int end = 9,
  }) async {
    return await _repo.searchDelivering(criteriales, end: end, start: start);
  }

  ResultFuture<DeliveringEntity> selectDeliveringById(String id) async {
    return await _repo.selectDeliveringById(id);
  }
}
