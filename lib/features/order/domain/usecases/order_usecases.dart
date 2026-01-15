import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/repository/order_repository.dart';
import 'package:e_tantana/shared/media/media_services.dart';

class OrderUsecases {
  final OrderRepository _orderRepository;
  final MediaServices _mediaServices;
  OrderUsecases(this._orderRepository, this._mediaServices);

  ResultFuture<OrderEntities> getOrderById(String orderId) =>
      _orderRepository.getOrderById(orderId);
  ResultFuture<OrderEntities> insertOrder(OrderEntities entity) =>
      _orderRepository.insertOrder(entity);
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
