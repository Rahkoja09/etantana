import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/repository/order_repository.dart';

class OrderUsecases {
  final OrderRepository _orderRepository;
  OrderUsecases(this._orderRepository);

  ResultFuture<OrderEntities> getOrderById(String orderId) =>
      _orderRepository.getOrderById(orderId);
  ResultFuture<OrderEntities> insertOrder(OrderEntities entity) =>
      _orderRepository.insertOrder(entity);
  ResultVoid deleteOrderById(String orderId) =>
      _orderRepository.deleteOrderById(orderId);
  ResultFuture<OrderEntities> updateOrder(OrderEntities entity) =>
      _orderRepository.updateOrder(entity);
  ResultFuture<List<OrderEntities>> researchOrder(OrderEntities? criterial) =>
      _orderRepository.researchOrder(criterial);
}
