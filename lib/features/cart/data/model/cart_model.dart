import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';

class CartModel extends CartEntity {
  CartModel({
    super.id,
    super.createdAt,
    // [CONSTRUCTOR_ANCHOR]
  });

  factory CartModel.fromMap(MapData data) {
    return CartModel(
      id: data['id'] as String?,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
      // [FROM_MAP_ANCHOR]
    );
  }

  MapData toMap() {
    return {
      if (id != null) 'id': id,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
      // [TO_MAP_ANCHOR]
    };
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      id: entity.id,
      createdAt: entity.createdAt,
      // [FROM_ENTITY_ANCHOR]
    );
  }
}