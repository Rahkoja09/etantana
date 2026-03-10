import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';

class ShopModel extends ShopEntity {
  ShopModel({
    super.id,
    super.createdAt,
    super.shopName,
    super.shopLogo,
    super.userId,
    super.socialLink,
    super.phoneContact,
    super.socialContact,
    super.slogan,
    super.description,
    // [CONSTRUCTOR_ANCHOR]
  });

  factory ShopModel.fromMap(MapData data) {
    return ShopModel(
      id: data['id'] as String?,
      createdAt:
          data['created_at'] != null
              ? DateTime.parse(data['created_at'])
              : null,
      shopName: data['shop_name'] as String?,
      shopLogo: data['shop_logo'] as String?,
      userId: data['user_id'] as String?,
      socialLink: data['social_link'] as String?,
      phoneContact: data['phone_contact'] as String?,
      socialContact: data['social_contact'] as String?,
      slogan: data['slogan'] as String?,
      description: data['description'] as String?,
      // [FROM_MAP_ANCHOR]
    );
  }

  MapData toMap() {
    return {
      if (id != null) 'id': id,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
      'shop_name': shopName,
      'shop_logo': shopLogo,
      'user_id': userId,
      'social_link': socialLink,
      'phone_contact': phoneContact,
      'social_contact': socialContact,
      'slogan': slogan,
      'description': description,
      // [TO_MAP_ANCHOR]
    };
  }

  factory ShopModel.fromEntity(ShopEntity entity) {
    return ShopModel(
      id: entity.id,
      createdAt: entity.createdAt,
      shopName: entity.shopName,
      shopLogo: entity.shopLogo,
      userId: entity.userId,
      socialLink: entity.socialLink,
      phoneContact: entity.phoneContact,
      socialContact: entity.socialContact,
      slogan: entity.slogan,
      description: entity.description,
      // [FROM_ENTITY_ANCHOR]
    );
  }
}
