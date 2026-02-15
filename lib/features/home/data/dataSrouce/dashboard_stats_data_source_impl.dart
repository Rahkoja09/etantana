import 'package:e_tantana/core/enums/order_status.dart';
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
          DateTime(now.year, now.month, now.day, 0, 0, 0).toIso8601String();
      final todayEnd =
          DateTime(
            now.year,
            now.month,
            now.day,
            23,
            59,
            59,
            999,
          ).toIso8601String();

      final deliveryRes = await _client
          .from('delivering')
          .select('*')
          .eq('status', DeliveryStatus.validated.name)
          .gte('date_of_delivering', todayStart)
          .count(CountOption.exact);

      final int deliveryToday = deliveryRes.count;

      final List<dynamic> ordersData = await _client
          .from('order')
          .select('id, products_and_quantities')
          .eq('status', DeliveryStatus.delivered.name)
          .gte('delivery_date', todayStart)
          .lte('delivery_date', todayEnd);

      final List<dynamic> ordersTotal = await _client
          .from('order')
          .select('id, products_and_quantities')
          .gte('created_at', todayStart);

      int totalOrders = ordersTotal.length;
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
