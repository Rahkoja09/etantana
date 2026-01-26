import 'package:e_tantana/core/utils/typedef/typedefs.dart';

abstract class StatisticalRepository {
  ResultFuture<List<double>> getDailySales();
  ResultFuture<List<double>> getAverageSalesPerWeek();
  ResultFuture<List<double>> getMonthlySales();
  ResultFuture<List<double>> getDailyOrders();
  ResultFuture<List<double>> getMonthlyOrders();
  ResultFuture<List<double>> getPremiumMonthlyProduct();
}
