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
  static const String _tableName = "user";
  @override
  Future<UserModel> insertUser(UserEntity entity) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw UnexceptedException(message: "Non authentifié");

      final model = UserModel.fromEntity(entity);
      final map =
          model.toMap()
            ..remove('id')
            ..remove('created_at');

      final data = await _client.from(_tableName).upsert(map).select().single();
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
        final name = criteria.name;
        if (name != null) {
          query = query.ilike("name", "%$name%");
        }
        final profilLink = criteria.profilLink;
        if (profilLink != null) {
          query = query.ilike("profil_link", "%$profilLink%");
        }
        final email = criteria.email;
        if (email != null) {
          query = query.ilike("email", "%$email%");
        }
        final sixDigitCode = criteria.sixDigitCode;
        if (sixDigitCode != null) {
          query = query.eq("six_digit_code", sixDigitCode);
        }
        final lastName = criteria.lastName;
        if (lastName != null) {
          query = query.ilike("last_name", "%$lastName%");
        }
        final birthDate = criteria.birthDate;
        if (birthDate != null) {
          query = query.eq("birth_date", birthDate);
        }
        final nickName = criteria.nickName;
        if (nickName != null) {
          query = query.ilike("nick_name", "%$nickName%");
        }
        final jobTitle = criteria.jobTitle;
        if (jobTitle != null) {
          query = query.ilike("job_title", "%$jobTitle%");
        }
        final userPlan = criteria.userPlan;
        if (userPlan != null) {
          query = query.ilike("user_plan", "%$userPlan%");
        }
        final isRegistered = criteria.isRegistered;
        if (isRegistered != null) {
          query = query.eq("is_registered", isRegistered);
        }
        final selectedShop = criteria.selectedShop;
        if (selectedShop != null) {
          query = query.ilike("selected_shop", "%$selectedShop%");
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
