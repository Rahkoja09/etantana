import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';

abstract class DeliveringRepository {
  ResultFuture<DeliveringEntity> insertDelivering();
  ResultFuture<DeliveringEntity> updateDeliveringByI(DeliveringEntity updates);
  ResultVoid deleteDeliveringById(String id);
  ResultFuture<List<DeliveringEntity>> searchDelivering(
    DeliveringEntity criteriales,
  );
  ResultFuture<DeliveringEntity> selectDeliveringById(String id);
}
