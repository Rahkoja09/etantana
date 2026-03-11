import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/features/feedback/data/model/feedback_model.dart';
import 'package:e_tantana/features/feedback/domain/entity/feedback_entity.dart';

abstract class FeedbackRemoteSource {
  Future<FeedbackModel> insertFeedback(FeedbackEntity entity);
  Future<FeedbackModel> updateFeedback(FeedbackEntity entity);
  Future<List<FeedbackModel>> searchFeedback(FeedbackEntity? criteria, {int start = 0, int end = 9});
  Future<FeedbackModel> getFeedbackById(String id);
  Future<void> deleteFeedbackById(String id);
}

class FeedbackRemoteSourceImpl implements FeedbackRemoteSource {
  final SupabaseClient _client;
  FeedbackRemoteSourceImpl(this._client);

  static const String _tableName = "feedbacks"; 

  @override
  Future<FeedbackModel> insertFeedback(FeedbackEntity entity) async {
    try {
      final model = FeedbackModel.fromEntity(entity);
      final data = await _client.from(_tableName).insert(model.toMap()).select().single();
      return FeedbackModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "POSTGREST_ERROR");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<FeedbackModel> updateFeedback(FeedbackEntity entity) async {
    try {
      if (entity.id == null) throw ApiException(message: "ID manquant pour la mise à jour");
      final model = FeedbackModel.fromEntity(entity);
      
      final data = await _client
          .from(_tableName)
          .update(model.toMap())
          .eq('id', entity.id!)
          .select()
          .single();
      return FeedbackModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "UPDATE_ERROR");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<List<FeedbackModel>> searchFeedback(FeedbackEntity? criteria, {int start = 0, int end = 9}) async {
    try {
      var query = _client.from(_tableName).select("*");

      if (criteria != null) {
        final id = criteria.id;
        if (id != null) {
          query = query.eq("id", id);
        }
                final user_id = criteria.user_id;
        if (user_id != null) {
          query = query.ilike("user_id", "%$user_id%");
        }
        final rates = criteria.rates;
        if (rates != null) {
          query = query.eq("rates", rates);
        }
        final comment = criteria.comment;
        if (comment != null) {
          query = query.ilike("comment", "%$comment%");
        }
        // [FILTERS_ANCHOR]
      }

      final res = await query
          .order("created_at", ascending: false)
          .range(start, end);

      return (res as List).map((data) => FeedbackModel.fromMap(data)).toList();
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<FeedbackModel> getFeedbackById(String id) async {
    try {
      final data = await _client.from(_tableName).select().eq('id', id).single();
      return FeedbackModel.fromMap(data);
    } catch (e) {
      throw UnexceptedException(message: "Élément introuvable : $e");
    }
  }

  @override
  Future<void> deleteFeedbackById(String id) async {
    try {
      await _client.from(_tableName).delete().eq("id", id);
    } catch (e) {
      throw UnexceptedException(message: "Erreur lors de la suppression : $e");
    }
  }
}