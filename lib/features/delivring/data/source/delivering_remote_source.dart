import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:e_tantana/features/delivring/data/model/delivering_model.dart';

abstract class DeliveringRemoteSource {
  Future<DeliveringModel> insertDelivering(DeliveringEntity entity);
  Future<void> deleteDeliveringById(String id);
  Future<DeliveringModel> updateDeliveringById(DeliveringEntity? entity);
  Future<List<DeliveringModel>> searchDelivering(
    DeliveringEntity criteriales, {
    int start = 0,
    int end = 9,
  });
  Future<DeliveringModel> selectDeliveringById(String id);
}

class DeliveringRemoteSourceImpl implements DeliveringRemoteSource {
  final SupabaseClient _client;
  DeliveringRemoteSourceImpl(this._client);

  @override
  Future<DeliveringModel> insertDelivering(DeliveringEntity entity) async {
    try {
      final model = DeliveringModel.fromEntity(entity);
      final data =
          await _client
              .from("delivering")
              .insert(model.toMap())
              .select()
              .single();

      return DeliveringModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<List<DeliveringModel>> searchDelivering(
    DeliveringEntity? criteriales, {
    int start = 0,
    int end = 9,
  }) async {
    try {
      dynamic query = _client.from("delivering").select("*");

      if (criteriales != null) {
        if (criteriales.id != null) query = query.eq("id", criteriales.id!);
        if (criteriales.orderId != null)
          query = query.eq("order_id", criteriales.orderId!);
        if (criteriales.status != null)
          query = query.eq("status", criteriales.status!);
        if (criteriales.description != null) {
          query = query.ilike("description", '%${criteriales.description}%');
        }
        if (criteriales.deliveringPrice != null) {
          query = query.eq("delivering_price", criteriales.deliveringPrice!);
        }
        if (criteriales.dateOfDelivering != null) {
          query = query.eq(
            "date_of_delivering",
            criteriales.dateOfDelivering!.toIso8601String(),
          );
        }
        if (criteriales.userDetails != null &&
            criteriales.userDetails!['user_name'] != null) {
          final nameToSearch = criteriales.userDetails!['user_name'];
          query = query.filter(
            "user_details->>user_name",
            "ilike",
            "%$nameToSearch%",
          );
        }
      }

      query = query.order("created_at", ascending: false);

      query = query.range(start, end);

      final res = await query;

      return (res as List)
          .map((data) => DeliveringModel.fromMap(data))
          .toList();
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<DeliveringModel> selectDeliveringById(String id) async {
    try {
      final data =
          await _client.from("delivering").select().eq("id", id).single();

      return DeliveringModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<void> deleteDeliveringById(String id) async {
    try {
      await _client.from("delivering").delete().eq("id", id);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<DeliveringModel> updateDeliveringById(DeliveringEntity? entity) async {
    try {
      if (entity == null)
        throw UnexceptedException(message: "No data to update");

      final model = DeliveringModel.fromEntity(entity);
      final data =
          await _client
              .from("delivering")
              .update(model.toMap())
              .eq("id", entity.id!)
              .select()
              .single();

      return DeliveringModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }
}
