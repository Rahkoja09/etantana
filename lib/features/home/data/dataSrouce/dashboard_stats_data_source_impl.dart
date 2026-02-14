import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/features/home/data/dataSrouce/dashboard_stats_data_source.dart';
import 'package:e_tantana/features/home/data/model/dashboard_stats_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardStatsDataSourceImpl implements DashboardStatsDataSource {
  final SupabaseClient _client;
  DashboardStatsDataSourceImpl(this._client);

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final now = DateTime.now();
      final todayStart =
          DateTime(now.year, now.month, now.day).toIso8601String();
      final deliveryRes = await _client
          .from('delivering')
          .select('*')
          .gte('created_at', todayStart)
          .count(CountOption.exact);

      final int deliveryToday = deliveryRes.count;

      final List<dynamic> ordersData = await _client
          .from('order')
          .select('id, products_and_quantities')
          .gte('created_at', todayStart);

      int totalOrders = ordersData.length;
      double dailyRevenue = 0;

      for (var order in ordersData) {
        final dynamic productsOrdered = order['products_and_quantities'];

        double price = 0.0;
        for (var product in productsOrdered) {
          price += product["unit_price"]! * product["quantity"]!;
        }
        dailyRevenue += price;
      }

      return DashboardStatsModel(
        period: "Aujourd'hui",
        revenue: dailyRevenue,
        revenueIncrease: "+0%",
        totalOrders: totalOrders,
        deliveryToday: deliveryToday,
      );
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message);
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }
}
