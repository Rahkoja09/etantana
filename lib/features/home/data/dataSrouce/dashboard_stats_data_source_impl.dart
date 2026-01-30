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
      final productRes = await _client
          .from('product')
          .select('*')
          .count(CountOption.exact);

      final int totalProducts = productRes.count;

      final now = DateTime.now();
      final todayStart =
          DateTime(now.year, now.month, now.day).toIso8601String();

      final List<dynamic> ordersData = await _client
          .from('order')
          .select('id, quantity, product(selling_price)')
          .gte('created_at', todayStart);

      int totalOrders = ordersData.length;
      double dailyRevenue = 0;

      for (var order in ordersData) {
        final dynamic product = order['product'];

        double price = 0.0;
        if (product is Map) {
          price = (product['selling_price'] as num?)?.toDouble() ?? 0.0;
        } else if (product is List && product.isNotEmpty) {
          price = (product[0]['selling_price'] as num?)?.toDouble() ?? 0.0;
        }

        final int qty = (order['quantity'] as num?)?.toInt() ?? 0;
        dailyRevenue += (price * qty);
      }

      return DashboardStatsModel(
        period: "Aujourd'hui",
        revenue: dailyRevenue,
        revenueIncrease: "+0%",
        totalOrders: totalOrders,
        totalProducts: totalProducts,
      );
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message);
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }
}
