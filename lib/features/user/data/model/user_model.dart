import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.createdAt,
        super.name,
    super.profilLink,
    super.email,
    super.sixDigitCode,
    // [CONSTRUCTOR_ANCHOR]
  });

  factory UserModel.fromMap(MapData data) {
    return UserModel(
      id: data['id'] as String?,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
            name: data['name'] as String?,
      profilLink: data['profil_link'] as String?,
      email: data['email'] as String?,
      sixDigitCode: data['six_digit_code'] as int?,
      // [FROM_MAP_ANCHOR]
    );
  }

  MapData toMap() {
    return {
      if (id != null) 'id': id,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
            'name': name,
      'profil_link': profilLink,
      'email': email,
      'six_digit_code': sixDigitCode,
      // [TO_MAP_ANCHOR]
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      createdAt: entity.createdAt,
            name: entity.name,
      profilLink: entity.profilLink,
      email: entity.email,
      sixDigitCode: entity.sixDigitCode,
      // [FROM_ENTITY_ANCHOR]
    );
  }
}