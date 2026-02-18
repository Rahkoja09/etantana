import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/data/dataSource/product_data_source.dart';
import 'package:e_tantana/features/product/data/model/product_model.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDataSourceImpl implements ProductDataSource {
  final SupabaseClient _client;
  ProductDataSourceImpl(this._client);

  @override
  Future<void> deleteProductById(String productId) async {
    try {
      final res = await _client.from("product").delete().eq("id", productId);
      if (res == null) {
        throw ApiException(
          message: "Erreur de suppression du produit : $productId",
        );
      }
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      final res =
          await _client.from("product").select().eq("id", productId).single();
      return ProductModel.fromMap(res);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<ProductModel> insertProduct(ProductEntities entities) async {
    try {
      final res =
          await _client
              .from("product")
              .insert({
                'name': entities.name,
                'quantity': entities.quantity,
                'description': entities.description,
                'type': entities.type,
                'details': entities.details,
                'images': entities.images,
                'e_id': entities.eId,
                'purchase_price': entities.purchasePrice,
                'selling_price': entities.sellingPrice,
                'future_product': entities.futureProduct,
                'is_pack': entities.isPack,
                'pack_composition': entities.packComposition,
              })
              .select()
              .single();
      return ProductModel.fromMap(res);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<List<ProductModel>> researchProduct(
    ProductEntities? criterial, {
    int start = 0,
    int end = 9,
  }) async {
    try {
      dynamic query = _client.from("product").select("*");

      if (criterial != null) {
        final eId = criterial.eId;
        final name = criterial.name;
        final quantity = criterial.quantity;
        final description = criterial.description;
        final type = criterial.type;
        final details = criterial.details;
        final purchasePrice = criterial.purchasePrice;
        final sellingPrice = criterial.sellingPrice;
        final futureProduct = criterial.futureProduct;
        final isPack = criterial.isPack;

        if (eId != null) query = query.eq("e_id", eId);
        if (name != null) query = query.ilike("name", '%$name%');
        if (quantity != null) query = query.eq("quantity", quantity);
        if (description != null) query = query.eq("description", description);
        if (type != null) query = query.eq("type", type);
        if (details != null) query = query.eq("details", details);
        if (isPack != null) query = query.eq("is_pack", isPack);
        if (futureProduct != null) {
          query = query.eq("future_product", futureProduct);
        }
        if (purchasePrice != null) {
          query = query.eq("purchase_price", purchasePrice);
        }
        if (sellingPrice != null) {
          query = query.eq("selling_price", sellingPrice);
        }
      }

      // trier par date ---------
      query = query.order("created_at", ascending: false);

      // lazy loading -----------
      query = query.range(start, end);

      final res = await query;
      return (res as List).map((data) => ProductModel.fromMap(data)).toList();
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductEntities entities) async {
    try {
      final updates = ProductModel.fromEntity(entities).toMap();
      final res =
          await _client
              .from("product")
              .update(updates)
              .eq('id', entities.id as Object)
              .select()
              .single();
      return ProductModel.fromMap(res);
    } on PostgrestException catch (e) {
      throw ApiException(message: e.message, code: e.code ?? "000");
    } catch (e) {
      throw UnexceptedException(message: "$e");
    }
  }

  @override
  Future<MapData> cancelAndRestock(String orderId) async {
    final response = await _client.rpc(
      'cancel_order_and_restock',
      params: {'p_order_id': orderId},
    );

    return response as Map<String, dynamic>;
  }
}
