import 'package:e_tantana/features/order/data/model/order_model.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';

abstract class OrderDataSource {
  Future<OrderModel> getOrderById(String orderId);
  Future<OrderModel> insertOrder(OrderEntities entity);
  Future<OrderModel> placeCompleteOrder(OrderEntities entity);
  Future<void> deleteOrderById(String orderId);
  Future<OrderModel> updateOrder(OrderEntities entity);
  Future<List<OrderModel>> researchOrder(
    OrderEntities? criterial, {
    int start = 0,
    int end = 9,
  });

  // statisticals order ---------------
  /*Future<int> getMonthlyOrders();
  Future<int> getDailyOrders();
  Future<int> getDailySales();
  Future<int> getAverageSalesPerWeek();*/
}
