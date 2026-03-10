import 'package:equatable/equatable.dart';

class ShopEntity extends Equatable {
  final String? id;
  final DateTime? createdAt;
  final String? shopName;
  final String? shopLogo;
  final String? userId;
  final String? socialLink;
  final String? phoneContact;
  final String? socialContact;
  final String? slogan;
  final String? description;
  // [FIELDS_ANCHOR]

  const ShopEntity({
    this.id,
    this.createdAt,
    this.shopName,
    this.shopLogo,
    this.userId,
    this.socialLink,
    this.phoneContact,
    this.socialContact,
    this.slogan,
    this.description,
    // [CONSTRUCTOR_ANCHOR]
  });

  ShopEntity copyWith({
    String? id,
    DateTime? createdAt,
    String? shopName,
    String? shopLogo,
    String? userId,
    String? socialLink,
    String? phoneContact,
    String? socialContact,
    String? slogan,
    String? description,
    // [COPYWITH_PARAMS_ANCHOR]
  }) {
    return ShopEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      shopName: shopName ?? this.shopName,
      shopLogo: shopLogo ?? this.shopLogo,
      userId: userId ?? this.userId,
      socialLink: socialLink ?? this.socialLink,
      phoneContact: phoneContact ?? this.phoneContact,
      socialContact: socialContact ?? this.socialContact,
      slogan: slogan ?? this.slogan,
      description: description ?? this.description,
      // [COPYWITH_RETURN_ANCHOR]
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    shopName,
    shopLogo,
    userId,
    socialLink,
    phoneContact,
    socialContact,
    slogan,
    description,
    // [PROPS_ANCHOR]
  ];
}
