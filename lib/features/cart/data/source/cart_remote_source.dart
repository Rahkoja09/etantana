import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/features/cart/data/model/cart_model.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';

abstract class CartRemoteSource {
  Future<CartModel> insertCart(CartEntity entity);
  Future<CartModel> updateCart(CartEntity entity);
  Future<List<CartModel>> searchCart(
    CartEntity? criteria, {
    int start = 0,
    int end = 9,
  });
  Future<CartModel> getCartById(String id);
  Future<void> deleteCartById(String id);
}

class CartRemoteSourceImpl implements CartRemoteSource {
  final SupabaseClient _client;
  CartRemoteSourceImpl(this._client);

  static const String _tableName = "carts";

  @override
  Future<CartModel> insertCart(CartEntity entity) async {
    try {
      final model = CartModel.fromEntity(entity);
      final data =
          await _client
              .from(_tableName)
              .insert(model.toMap())
              .select()
              .single();
      return CartModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "POSTGREST_ERROR");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<CartModel> updateCart(CartEntity entity) async {
    try {
      if (entity.id == null)
        throw ApiException(message: "ID manquant pour la mise à jour");
      final model = CartModel.fromEntity(entity);

      final data =
          await _client
              .from(_tableName)
              .update(model.toMap())
              .eq('id', entity.id!)
              .select()
              .single();
      return CartModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "UPDATE_ERROR");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<List<CartModel>> searchCart(
    CartEntity? criteria, {
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
        final chosenVariant = criteria.chosenVariant;
        if (chosenVariant != null) {
          query = query.ilike("chosen_variant", "%$chosenVariant%");
        }
        final productId = criteria.productId;
        if (productId != null) {
          query = query.ilike("product_id", "%$productId%");
        }
        final productName = criteria.productName;
        if (productName != null) {
          query = query.ilike("product_name", "%$productName%");
        }
        final productImage = criteria.productImage;
        if (productImage != null) {
          query = query.ilike("product_image", "%$productImage%");
        }
        final unitPrice = criteria.unitPrice;
        if (unitPrice != null) {
          query = query.eq("unit_price", unitPrice);
        }
        final purchasePrice = criteria.purchasePrice;
        if (purchasePrice != null) {
          query = query.eq("purchase_price", purchasePrice);
        }
        final quantity = criteria.quantity;
        if (quantity != null) {
          query = query.eq("quantity", quantity);
        }
        final shopId = criteria.shopId;
        if (shopId != null) {
          query = query.ilike("shop_id", "%$shopId%");
        }
        final user_id = criteria.user_id;
        if (user_id != null) {
          query = query.ilike("user_id", "%$user_id%");
        }
        // [FILTERS_ANCHOR]
      }

      final res = await query
          .order("created_at", ascending: false)
          .range(start, end);

      return (res as List).map((data) => CartModel.fromMap(data)).toList();
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<CartModel> getCartById(String id) async {
    try {
      final data =
          await _client.from(_tableName).select().eq('id', id).single();
      return CartModel.fromMap(data);
    } catch (e) {
      throw UnexceptedException(message: "Élément introuvable : $e");
    }
  }

  @override
  Future<void> deleteCartById(String id) async {
    try {
      await _client.from(_tableName).delete().eq("id", id);
    } catch (e) {
      throw UnexceptedException(message: "Erreur lors de la suppression : $e");
    }
  }
}
