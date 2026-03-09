import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final DateTime? createdAt;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? shopName;
  final String? facebookLink;
  final String? slogan;
  final String? whatsappContact;
  // [FIELDS_ANCHOR]

  const UserEntity({
    this.id,
    this.createdAt,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.shopName,
    this.facebookLink,
    this.slogan,
    this.whatsappContact,
    // [CONSTRUCTOR_ANCHOR]
  });

  UserEntity copyWith({
    String? id,
    DateTime? createdAt,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? shopName,
    String? facebookLink,
    String? slogan,
    String? whatsappContact,
    // [COPYWITH_PARAMS_ANCHOR]
  }) {
    return UserEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      shopName: shopName ?? this.shopName,
      facebookLink: facebookLink ?? this.facebookLink,
      slogan: slogan ?? this.slogan,
      whatsappContact: whatsappContact ?? this.whatsappContact,
      // [COPYWITH_RETURN_ANCHOR]
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    email,
    password,
    firstName,
    lastName,
    shopName,
    facebookLink,
    slogan,
    whatsappContact,
    // [PROPS_ANCHOR]
  ];
}
