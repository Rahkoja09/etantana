import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/delivring/domain/mapper/order_to_delivering_mapper.dart';
import 'package:e_tantana/features/delivring/domain/repository/delivering_repository.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/repository/order_repository.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';

class OrderUsecases {
  final OrderRepository _orderRepository;
  final DeliveringRepository _deliveringRepository;
  final ProductRepository _productRepository;
  OrderUsecases(
    this._orderRepository,
    this._deliveringRepository,
    this._productRepository,
  );

  ResultFuture<OrderEntities> getOrderById(String orderId) =>
      _orderRepository.getOrderById(orderId);

  ResultFuture<OrderEntities> addOrder(OrderEntities entity) async =>
      await _orderRepository.insertOrder(entity);

  ResultFuture<OrderEntities> placeCompleteOrder(OrderEntities entity) async =>
      await _orderRepository.placeCompleteOrder(entity);

  ResultVoid deleteOrderById(String orderId) async {
    try {
      final deliveringRes = await _deliveringRepository.deleteDeliveringById(
        orderId,
      );

      return await deliveringRes.fold((failure) async => Left(failure), (
        _,
      ) async {
        final orderRes = await _orderRepository.deleteOrderById(orderId);

        return orderRes.fold((failure) => Left(failure), (_) => Right(null));
      });
    } catch (e) {
      return Left(UnexceptedFailure(e.toString(), "500"));
    }
  }

  ResultFuture<OrderEntities> updateOrderFlow(OrderEntities entity) async {
    try {
      final orderRes = await _orderRepository.updateOrder(entity);

      return await orderRes.fold((failure) async => Left(failure), (
        order,
      ) async {
        final deliveringRes = await _deliveringRepository.selectDeliveringById(
          order.id!,
        );

        return await deliveringRes.fold((failure) async => Left(failure), (
          delivery,
        ) async {
          final updates = delivery.copyWith(status: order.status);
          final deliveryUpdateRes = await _deliveringRepository
              .updateDeliveringByI(updates);

          return deliveryUpdateRes.fold(
            (failure) => Left(failure),
            (_) => Right(order),
          );
        });
      });
    } catch (e) {
      return Left(UnexceptedFailure(e.toString(), "500"));
    }
  }

  ResultFuture<List<OrderEntities>> researchOrder(
    OrderEntities? criterial, {
    int start = 0,
    int end = 9,
  }) => _orderRepository.researchOrder(criterial, start: start, end: end);
}
