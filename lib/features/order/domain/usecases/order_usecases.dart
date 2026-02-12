import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';
import 'package:e_tantana/features/delivring/domain/mapper/order_to_delivering_mapper.dart';
import 'package:e_tantana/features/delivring/domain/repository/delivering_repository.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/repository/order_repository.dart';

class OrderUsecases {
  final OrderRepository _orderRepository;
  final DeliveringRepository _deliveringRepository;
  OrderUsecases(this._orderRepository, this._deliveringRepository);

  ResultFuture<OrderEntities> getOrderById(String orderId) =>
      _orderRepository.getOrderById(orderId);
  ResultFuture<OrderEntities> processOrderFlow(OrderEntities entity) async {
    try {
      final orderRes = await _orderRepository.insertOrder(entity);

      return await orderRes.fold((failure) async => Left(failure), (
        order,
      ) async {
        final deliveringData = order.toDelivering();
        final deliveryRes = await _deliveringRepository.insertDelivering(
          deliveringData,
        );
        return deliveryRes.fold(
          (failure) => Left(failure),
          (_) => Right(order),
        );
      });
    } catch (e) {
      return Left(UnexceptedFailure(e.toString(), "500"));
    }
  }

  ResultVoid deleteOrderById(String orderId) =>
      _orderRepository.deleteOrderById(orderId);
  ResultFuture<OrderEntities> updateOrder(OrderEntities entity) =>
      _orderRepository.updateOrder(entity);
  ResultFuture<List<OrderEntities>> researchOrder(
    OrderEntities? criterial, {
    int start = 0,
    int end = 9,
  }) => _orderRepository.researchOrder(criterial, start: start, end: end);
}
