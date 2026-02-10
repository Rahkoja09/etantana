import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/features/order/data/dataSource/order_data_source.dart';
import 'package:e_tantana/features/order/data/model/order_model.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderDataSourceImpl implements OrderDataSource {
  final SupabaseClient _client;
  OrderDataSourceImpl(this._client);

  @override
  Future<void> deleteOrderById(String orderId) async {
    try {
      await _client.from("order").delete().eq("id", orderId);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final res =
          await _client.from("order").select().eq("id", orderId).single();
      return OrderModel.fromMap(res);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<OrderModel> insertOrder(OrderEntities entity) async {
    try {
      final res =
          await _client
              .from("order")
              .insert({
                'status': entity.status,
                'quantity': entity.quantity,
                'invoice_link': entity.invoiceLink,
                'products_and_quantities': entity.productsAndQuantities,
                'client_name': entity.clientName,
                'client_tel': entity.clientTel,
                'client_adrs': entity.clientAdrs,
                'details': entity.details,
                'delivery_costs': entity.deliveryCosts,
              })
              .select()
              .single();
      return OrderModel.fromMap(res);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<List<OrderModel>> researchOrder(
    OrderEntities? criterial, {
    int start = 0,
    int end = 9,
  }) async {
    try {
      dynamic query = _client.from("order").select("*");

      if (criterial != null) {
        final status = criterial.status;
        final invoiceLink = criterial.invoiceLink;
        final productsAndQuantities = criterial.productsAndQuantities;
        final quantity = criterial.quantity;
        final details = criterial.details;
        final clientName = criterial.clientName;
        final clientTel = criterial.clientTel;
        final clientAdrs = criterial.clientAdrs;

        if (status != null) query = query.eq("status", status);
        if (invoiceLink != null) query = query.eq("invoice_link", invoiceLink);
        if (productsAndQuantities != null) {
          query = query.eq("products_and_quantities", productsAndQuantities);
        }
        if (quantity != null) query = query.eq("quantity", quantity);
        if (details != null) query = query.eq("details", details);
        if (clientName != null) {
          query = query.ilike("client_name", '%$clientName%');
        }
        if (clientTel != null) query = query.eq("client_tel", clientTel);
        if (clientAdrs != null) query = query.eq("client_adrs", clientAdrs);
      }

      query = query.order("created_at", ascending: false);
      query = query.range(start, end);
      final res = await query;
      return (res as List).map((data) => OrderModel.fromMap(data)).toList();
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<OrderModel> updateOrder(OrderEntities entity) async {
    try {
      final updates = OrderModel.fromEntity(entity).toMap();
      final res =
          await _client
              .from("order")
              .update(updates)
              .eq("id", entity.id!)
              .select()
              .single();
      return OrderModel.fromMap(res);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }
}
