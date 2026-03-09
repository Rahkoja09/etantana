import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/features/user/data/model/user_model.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';

abstract class UserRemoteSource {
  Future<UserModel> insertUser(UserEntity entity);
  Future<UserModel> updateUser(UserEntity entity);
  Future<List<UserModel>> searchUser(
    UserEntity? criteria, {
    int start = 0,
    int end = 9,
  });
  Future<UserModel> getUserById(String id);
  Future<void> deleteUserById(String id);
}

class UserRemoteSourceImpl implements UserRemoteSource {
  final SupabaseClient _client;
  UserRemoteSourceImpl(this._client);

  static const String _tableName = "users";

  @override
  Future<UserModel> insertUser(UserEntity entity) async {
    try {
      final model = UserModel.fromEntity(entity);
      final data =
          await _client
              .from(_tableName)
              .insert(model.toMap())
              .select()
              .single();
      return UserModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "POSTGREST_ERROR");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<UserModel> updateUser(UserEntity entity) async {
    try {
      if (entity.id == null)
        throw ApiException(message: "ID manquant pour la mise à jour");
      final model = UserModel.fromEntity(entity);

      final data =
          await _client
              .from(_tableName)
              .update(model.toMap())
              .eq('id', entity.id!)
              .select()
              .single();
      return UserModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "UPDATE_ERROR");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<List<UserModel>> searchUser(
    UserEntity? criteria, {
    int start = 0,
    int end = 9,
  }) async {
    try {
      var query = _client.from(_tableName).select("*");

      if (criteria != null) {
        final id = criteria.id;
        if (id != null) {
          query = query.eq("id", id);
        }
        final email = criteria.email;
        if (email != null) {
          query = query.ilike("email", "%$email%");
        }
        final password = criteria.password;
        if (password != null) {
          query = query.ilike("password", "%$password%");
        }
        final firstName = criteria.firstName;
        if (firstName != null) {
          query = query.ilike("first_name", "%$firstName%");
        }
        final lastName = criteria.lastName;
        if (lastName != null) {
          query = query.ilike("last_name", "%$lastName%");
        }
        final shopName = criteria.shopName;
        if (shopName != null) {
          query = query.ilike("shop_name", "%$shopName%");
        }
        final facebookLink = criteria.facebookLink;
        if (facebookLink != null) {
          query = query.ilike("facebook_link", "%$facebookLink%");
        }
        final slogan = criteria.slogan;
        if (slogan != null) {
          query = query.ilike("slogan", "%$slogan%");
        }
        final whatsappContact = criteria.whatsappContact;
        if (whatsappContact != null) {
          query = query.ilike("whatsapp_contact", "%$whatsappContact%");
        }
        // [FILTERS_ANCHOR]
      }

      final res = await query
          .order("created_at", ascending: false)
          .range(start, end);

      return (res as List).map((data) => UserModel.fromMap(data)).toList();
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final data =
          await _client.from(_tableName).select().eq('id', id).single();
      return UserModel.fromMap(data);
    } catch (e) {
      throw UnexceptedException(message: "Élément introuvable : $e");
    }
  }

  @override
  Future<void> deleteUserById(String id) async {
    try {
      await _client.from(_tableName).delete().eq("id", id);
    } catch (e) {
      throw UnexceptedException(message: "Erreur lors de la suppression : $e");
    }
  }
}
