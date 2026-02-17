import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/data/dataSource/order_data_source.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final NetworkInfo _networkInfo;
  final OrderDataSource _orderDataSource;
  OrderRepositoryImpl(this._networkInfo, this._orderDataSource);

  @override
  ResultVoid deleteOrderById(String orderId) async {
    return await _executeAction(
      () => _orderDataSource.deleteOrderById(orderId),
    );
  }

  @override
  ResultFuture<OrderEntities> getOrderById(String orderId) async {
    return await _executeAction(() => _orderDataSource.getOrderById(orderId));
  }

  @override
  ResultFuture<OrderEntities> insertOrder(OrderEntities entity) async {
    return await _executeAction(() => _orderDataSource.insertOrder(entity));
  }

  @override
  ResultFuture<List<OrderEntities>> researchOrder(
    OrderEntities? criterial, {
    int start = 0,
    int end = 9,
  }) async {
    return await _executeAction(
      () => _orderDataSource.researchOrder(criterial, start: start, end: end),
    );
  }

  @override
  ResultFuture<OrderEntities> updateOrder(OrderEntities entity) async {
    return await _executeAction(() => _orderDataSource.updateOrder(entity));
  }

  @override
  ResultFuture<OrderEntities> placeCompleteOrder(OrderEntities entity) async {
    return await _executeAction(
      () => _orderDataSource.placeCompleteOrder(entity),
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
