import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';

abstract class OrderRepository {
  ResultFuture<OrderEntities> getOrderById(String orderId);
  ResultFuture<OrderEntities> insertOrder(OrderEntities entity);
  ResultVoid deleteOrderById(String orderId);
  ResultFuture<OrderEntities> updateOrder(OrderEntities entity);
  ResultFuture<List<OrderEntities>> researchOrder(OrderEntities? criterial);
}
