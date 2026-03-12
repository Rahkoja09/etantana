import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/features/shop/data/model/shop_model.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';

abstract class ShopRemoteSource {
  Future<ShopModel> insertShop(ShopEntity entity);
  Future<ShopModel> createShopAndUpdateUser(ShopEntity entity);
  Future<ShopModel> updateShop(ShopEntity entity);
  Future<List<ShopModel>> searchShop(
    ShopEntity? criteria, {
    int start = 0,
    int end = 9,
  });
  Future<ShopModel> getShopById(String id);
  Future<void> deleteShopById(String id);
}

class ShopRemoteSourceImpl implements ShopRemoteSource {
  final SupabaseClient _client;
  ShopRemoteSourceImpl(this._client);

  static const String _tableName = "shops";

  @override
  Future<ShopModel> insertShop(ShopEntity entity) async {
    try {
      final model = ShopModel.fromEntity(entity);
      final data =
          await _client
              .from(_tableName)
              .insert(model.toMap())
              .select()
              .single();
      return ShopModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "POSTGREST_ERROR");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<ShopModel> createShopAndUpdateUser(ShopEntity entity) async {
    try {
      // Appel RPC atomique ------
      final shopId = await _client.rpc(
        'create_shop_and_update_user',
        params: {
          'p_user_id': entity.userId,
          'p_shop_name': entity.shopName,
          'p_slogan': entity.slogan,
          'p_description': entity.description,
          'p_phone_contact': entity.phoneContact,
          'p_social_link': entity.socialLink,
          'p_social_contact': entity.socialContact,
          'p_shop_logo': entity.shopLogo,
        },
      );
      final data =
          await _client.from("shops").select().eq("id", shopId).single();

      return ShopModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "POSTGREST_ERROR");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<ShopModel> updateShop(ShopEntity entity) async {
    try {
      if (entity.id == null)
        throw ApiException(message: "ID manquant pour la mise à jour");
      final model = ShopModel.fromEntity(entity);

      final data =
          await _client
              .from(_tableName)
              .update(model.toMap())
              .eq('id', entity.id!)
              .select()
              .single();
      return ShopModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "UPDATE_ERROR");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<List<ShopModel>> searchShop(
    ShopEntity? criteria, {
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
        final shopName = criteria.shopName;
        if (shopName != null) {
          query = query.ilike("shop_name", "%$shopName%");
        }
        final shopLogo = criteria.shopLogo;
        if (shopLogo != null) {
          query = query.ilike("shop_logo", "%$shopLogo%");
        }
        final userId = criteria.userId;
        if (userId != null) {
          query = query.ilike("user_id", "%$userId%");
        }
        final socialLink = criteria.socialLink;
        if (socialLink != null) {
          query = query.ilike("social_link", "%$socialLink%");
        }
        final phoneContact = criteria.phoneContact;
        if (phoneContact != null) {
          query = query.ilike("phone_contact", "%$phoneContact%");
        }
        final socialContact = criteria.socialContact;
        if (socialContact != null) {
          query = query.ilike("social_contact", "%$socialContact%");
        }
        final slogan = criteria.slogan;
        if (slogan != null) {
          query = query.ilike("slogan", "%$slogan%");
        }
        final description = criteria.description;
        if (description != null) {
          query = query.ilike("description", "%$description%");
        }
        // [FILTERS_ANCHOR]
      }

      final res = await query
          .order("created_at", ascending: false)
          .range(start, end);

      return (res as List).map((data) => ShopModel.fromMap(data)).toList();
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<ShopModel> getShopById(String id) async {
    try {
      final data =
          await _client.from(_tableName).select().eq('id', id).single();
      return ShopModel.fromMap(data);
    } catch (e) {
      throw UnexceptedException(message: "Élément introuvable : $e");
    }
  }

  @override
  Future<void> deleteShopById(String id) async {
    try {
      await _client.from(_tableName).delete().eq("id", id);
    } catch (e) {
      throw UnexceptedException(message: "Erreur lors de la suppression : $e");
    }
  }
}
