import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';

class CartModel extends CartEntity {
  CartModel({
    super.id,
    super.createdAt,
    super.productId,
    super.productName,
    super.productImage,
    super.unitPrice,
    super.purchasePrice,
    super.quantity,
    super.shopId,
    super.chosenVariant,
    // [CONSTRUCTOR_ANCHOR]
  });

  factory CartModel.fromMap(MapData data) {
    return CartModel(
      id: data['id'] as String?,
      createdAt:
          data['created_at'] != null
              ? DateTime.parse(data['created_at'])
              : null,
      productId: data['product_id'] as String?,
      productName: data['product_name'] as String?,
      productImage: data['product_image'] as String?,
      unitPrice: data['unit_price'] as double?,
      purchasePrice: data['purchase_price'] as double?,
      quantity: data['quantity'] as int?,
      shopId: data['shop_id'] as String?,
      chosenVariant:
          data['chosen_variant'] != null
              ? Map<String, dynamic>.from(data['chosen_variant'] as Map)
              : null,
      // [FROM_MAP_ANCHOR]
    );
  }

  MapData toMap() {
    return {
      if (id != null) 'id': id,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'unit_price': unitPrice,
      'purchase_price': purchasePrice,
      'quantity': quantity,
      'shop_id': shopId,
      'chosen_variant': chosenVariant,
      // [TO_MAP_ANCHOR]
    };
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      id: entity.id,
      createdAt: entity.createdAt,
      productId: entity.productId,
      productName: entity.productName,
      productImage: entity.productImage,
      unitPrice: entity.unitPrice,
      purchasePrice: entity.purchasePrice,
      quantity: entity.quantity,
      shopId: entity.shopId,
      chosenVariant: entity.chosenVariant,
      // [FROM_ENTITY_ANCHOR]
    );
  }
}
