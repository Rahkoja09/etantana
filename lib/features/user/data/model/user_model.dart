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
    super.myShops,
    super.lastName,
    super.birthDate,
    super.nickName,
    super.jobTitle,
    super.userPlan,
    super.isRegistered,
    super.selectedShop,
    // [CONSTRUCTOR_ANCHOR]
  });

  factory UserModel.fromMap(MapData data) {
    return UserModel(
      id: data['id'] as String?,
      createdAt:
          data['created_at'] != null
              ? DateTime.parse(data['created_at'])
              : null,
      name: data['name'] as String?,
      profilLink: data['profil_link'] as String?,
      email: data['email'] as String?,
      sixDigitCode: data['six_digit_code'] as int?,
      myShops: List<String>.from(data['my_shops'] ?? []),
      lastName: data['last_name'] as String?,
      birthDate:
          data['birth_date'] != null
              ? DateTime.parse(data['birth_date'])
              : null,
      nickName: data['nick_name'] as String?,
      jobTitle: data['job_title'] as String?,
      userPlan: data['user_plan'] as String?,
      isRegistered: data['is_registered'] as bool?,
      selectedShop: data['selected_shop'] as String?,
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
      'my_shops': myShops,
      'last_name': lastName,
      'birth_date': birthDate?.toIso8601String(),
      'nick_name': nickName,
      'job_title': jobTitle,
      'user_plan': userPlan,
      'is_registered': isRegistered,
      'selected_shop': selectedShop,
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
      myShops: entity.myShops,
      lastName: entity.lastName,
      birthDate: entity.birthDate,
      nickName: entity.nickName,
      jobTitle: entity.jobTitle,
      userPlan: entity.userPlan,
      isRegistered: entity.isRegistered,
      selectedShop: entity.selectedShop,
      // [FROM_ENTITY_ANCHOR]
    );
  }
}
