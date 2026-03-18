import 'package:e_tantana/core/enums/order_status.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/features/home/data/dataSrouce/dashboard_stats_data_source.dart';
import 'package:e_tantana/features/home/data/model/dashboard_stats_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardStatsDataSourceImpl implements DashboardStatsDataSource {
  final SupabaseClient _client;
  DashboardStatsDataSourceImpl(this._client);

  @override
  Future<DashboardStatsModel> getDashboardStats(String? shopId) async {
    try {
      final now = DateTime.now();

      final day7Start =
          DateTime(now.year, now.month, now.day - 6).toIso8601String();
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
      final todayStart =
          DateTime(now.year, now.month, now.day).toIso8601String();

      // ── Livraisons validées aujourd'hui ───────────────────
      final deliveryQuery = _client
          .from('delivering')
          .select('*')
          .eq('status', DeliveryStatus.validated.name)
          .gte('date_of_delivering', todayStart)
          .lte('date_of_delivering', todayEnd);

      final deliveryRes = await (shopId != null
              ? deliveryQuery.eq('shop_id', shopId)
              : deliveryQuery)
          .count(CountOption.exact);

      final int deliveryToday = deliveryRes.count;

      // ── Commandes totales aujourd'hui ─────────────────────
      final ordersTotalQuery = _client
          .from('order')
          .select('id')
          .gte('created_at', todayStart)
          .lte('created_at', todayEnd);

      final List<dynamic> ordersTotal =
          await (shopId != null
              ? ordersTotalQuery.eq('shop_id', shopId)
              : ordersTotalQuery);

      final int totalOrders = ordersTotal.length;

      // ── Commandes livrées sur 7 jours ─────────────────────
      final orders7DaysQuery = _client
          .from('order')
          .select('delivery_date, products_and_quantities')
          .eq('status', DeliveryStatus.delivered.name)
          .gte('delivery_date', day7Start)
          .lte('delivery_date', todayEnd);

      final List<dynamic> orders7Days =
          await (shopId != null
              ? orders7DaysQuery.eq('shop_id', shopId)
              : orders7DaysQuery);

      // ── Calcul revenu par jour sur 7 jours ────────────────
      final Map<String, double> revenuePerDay = {};

      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        final key =
            "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
        revenuePerDay[key] = 0.0;
      }

      for (var order in orders7Days) {
        final String? deliveryDate = order['delivery_date'];
        if (deliveryDate == null) continue;

        final dateKey = deliveryDate.substring(0, 10);
        if (!revenuePerDay.containsKey(dateKey)) continue;

        double price = 0.0;
        final dynamic productsOrdered = order['products_and_quantities'];
        for (var product in productsOrdered) {
          price += (product["unit_price"] ?? 0) * (product["quantity"] ?? 0);
        }
        revenuePerDay[dateKey] = (revenuePerDay[dateKey] ?? 0) + price;
      }

      final List<double> revenueHistory = revenuePerDay.values.toList();

      final double today = revenueHistory.last;
      final double yesterday =
          revenueHistory.length >= 2
              ? revenueHistory[revenueHistory.length - 2]
              : 0;

      String revenueIncrease = "+0%";
      if (yesterday > 0) {
        final double diff = ((today - yesterday) / yesterday) * 100;
        revenueIncrease = "${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(0)}%";
      } else if (today > 0) {
        revenueIncrease = "+100%";
      }

      return DashboardStatsModel(
        period: "Aujourd'hui",
        revenue: revenueHistory,
        revenueIncrease: revenueIncrease,
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
