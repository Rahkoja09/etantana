import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String? id;
  final DateTime? createdAt;
  final String? productId;
  final String? productName;
  final String? productImage;
  final double? unitPrice;
  final double? purchasePrice;
  final Map<String, dynamic>? chosenVariant;
  final int? quantity;
  final String? shopId;
  double get totalPrice => (unitPrice ?? 0) * (quantity ?? 0);
  final String? user_id;
  // [FIELDS_ANCHOR]

  const CartEntity({
    this.id,
    this.createdAt,
    this.productId,
    this.productName,
    this.productImage,
    this.unitPrice,
    this.purchasePrice,
    this.chosenVariant,
    this.quantity,
    this.shopId,
    this.user_id,
    // [CONSTRUCTOR_ANCHOR]
  });

  CartEntity copyWith({
    String? id,
    DateTime? createdAt,
    String? productId,
    String? productName,
    String? productImage,
    double? unitPrice,
    double? purchasePrice,
    Map<String, dynamic>? chosenVariant,
    int? quantity,
    String? shopId,
    String? user_id,
    // [COPYWITH_PARAMS_ANCHOR]
  }) {
    return CartEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      unitPrice: unitPrice ?? this.unitPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      chosenVariant: chosenVariant ?? this.chosenVariant,
      quantity: quantity ?? this.quantity,
      shopId: shopId ?? this.shopId,
      user_id: user_id ?? this.user_id,
      // [COPYWITH_RETURN_ANCHOR]
    );
  }

  MapData toOrderFormat() {
    return {
      "id": productId,
      "quantity": quantity ?? 1,
      "unit_price": unitPrice,
      "product_name": productName,
      "purchase_price": purchasePrice,
      "shop_id": shopId,
      "chosen_variant": chosenVariant,
    };
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    productId,
    productName,
    productImage,
    unitPrice,
    purchasePrice,
    chosenVariant,
    quantity,
    shopId,
    user_id,
    // [PROPS_ANCHOR]
  ];
}
