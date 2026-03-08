import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.createdAt,
        super.email,
    super.password,
    super.firstName,
    super.lastName,
    super.shopName,
    super.facebookLink,
    super.slogan,
    super.whatsappContact,
    // [CONSTRUCTOR_ANCHOR]
  });

  factory UserModel.fromMap(MapData data) {
    return UserModel(
      id: data['id'] as String?,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
            email: data['email'] as String?,
      password: data['password'] as String?,
      firstName: data['first_name'] as String?,
      lastName: data['last_name'] as String?,
      shopName: data['shop_name'] as String?,
      facebookLink: data['facebook_link'] as String?,
      slogan: data['slogan'] as String?,
      whatsappContact: data['whatsapp_contact'] as String?,
      // [FROM_MAP_ANCHOR]
    );
  }

  MapData toMap() {
    return {
      if (id != null) 'id': id,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
            'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'shop_name': shopName,
      'facebook_link': facebookLink,
      'slogan': slogan,
      'whatsapp_contact': whatsappContact,
      // [TO_MAP_ANCHOR]
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      createdAt: entity.createdAt,
            email: entity.email,
      password: entity.password,
      firstName: entity.firstName,
      lastName: entity.lastName,
      shopName: entity.shopName,
      facebookLink: entity.facebookLink,
      slogan: entity.slogan,
      whatsappContact: entity.whatsappContact,
      // [FROM_ENTITY_ANCHOR]
    );
  }
}