import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';

abstract class DeliveringRepository {
  ResultFuture<DeliveringEntity> insertDelivering(DeliveringEntity delivering);
  ResultFuture<DeliveringEntity> updateDeliveringByI(DeliveringEntity updates);
  ResultVoid deleteDeliveringById(String id);
  ResultFuture<List<DeliveringEntity>> searchDelivering(
    DeliveringEntity criteriales, {
    int start = 0,
    int end = 9,
  });
  ResultFuture<DeliveringEntity> selectDeliveringById(String id);
}
