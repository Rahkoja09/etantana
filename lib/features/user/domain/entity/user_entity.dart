import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final DateTime? createdAt;
  final String? name;
  final String? profilLink;
  final String? email;
  final int? sixDigitCode;
  final List<String>? myShops;
  final String? lastName;
  final DateTime? birthDate;
  final String? nickName;
  final String? jobTitle;
  final String? userPlan;
  final bool? isRegistered;
  final String? selectedShop;
  // [FIELDS_ANCHOR]

  const UserEntity({
    this.id,
    this.createdAt,
    this.name,
    this.profilLink,
    this.email,
    this.sixDigitCode,
    this.myShops,
    this.lastName,
    this.birthDate,
    this.nickName,
    this.jobTitle,
    this.userPlan,
    this.isRegistered,
    this.selectedShop,
    // [CONSTRUCTOR_ANCHOR]
  });

  UserEntity copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? profilLink,
    String? email,
    int? sixDigitCode,
    List<String>? myShops,
    String? lastName,
    DateTime? birthDate,
    String? nickName,
    String? jobTitle,
    String? userPlan,
    bool? isRegistered,
    String? selectedShop,
    // [COPYWITH_PARAMS_ANCHOR]
  }) {
    return UserEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      profilLink: profilLink ?? this.profilLink,
      email: email ?? this.email,
      sixDigitCode: sixDigitCode ?? this.sixDigitCode,
      myShops: myShops ?? this.myShops,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      nickName: nickName ?? this.nickName,
      jobTitle: jobTitle ?? this.jobTitle,
      userPlan: userPlan ?? this.userPlan,
      isRegistered: isRegistered ?? this.isRegistered,
      selectedShop: selectedShop ?? this.selectedShop,
      // [COPYWITH_RETURN_ANCHOR]
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    name,
    profilLink,
    email,
    sixDigitCode,
    myShops,
    lastName,
    birthDate,
    nickName,
    jobTitle,
    userPlan,
    isRegistered,
    selectedShop,
    // [PROPS_ANCHOR]
  ];
}
