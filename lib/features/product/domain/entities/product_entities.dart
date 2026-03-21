import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:equatable/equatable.dart';

class ProductEntities extends Equatable {
  final String? id;
  final String? userId;
  final String? eId;
  final DateTime? createdAt;
  final String? name;
  final int? quantity;
  final String? description;
  final String? type;
  final List<Map<String, dynamic>>? variant;
  final String? images;
  final double? purchasePrice;
  final double? sellingPrice;
  final bool? futureProduct;
  final bool? isPack;
  final String? shopId;
  final List<MapData>? packComposition;

  const ProductEntities({
    this.id,
    this.userId,
    this.createdAt,
    this.eId,
    this.name,
    this.quantity,
    this.description,
    this.variant,
    this.images,
    this.type,
    this.purchasePrice,
    this.sellingPrice,
    this.futureProduct,
    this.isPack = false,
    this.packComposition,
    this.shopId,
  });

  ProductEntities copyWith({
    String? id,
    String? userId,
    String? eId,
    DateTime? createdAt,
    String? name,
    int? quantity,
    String? description,
    String? type,
    List<Map<String, dynamic>>? variant,
    String? images,
    double? purchasePrice,
    double? sellingPrice,
    bool? futureProduct,
    bool? isPack,
    List<MapData>? packComposition,
    String? shopId,
  }) {
    return ProductEntities(
      name: name ?? this.name,
      userId: userId ?? this.userId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      variant: variant ?? this.variant,
      eId: eId ?? this.eId,
      id: id ?? this.id,
      images: images ?? this.images,
      type: type ?? this.type,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      futureProduct: futureProduct ?? this.futureProduct,
      isPack: isPack ?? this.isPack,
      packComposition: packComposition ?? this.packComposition,
      shopId: shopId ?? this.shopId,
    );
  }

  MapData toProductVariant({
    required String productId,
    required String variantName,
    required String variantType,
    required String property,
    required String propertyType,
    String? variantImageLink,
    required int variantQuantity,
    double? variantPrice,
  }) {
    return {
      "product_id": productId,
      "name": variantName,
      "variant_type": variantType,
      "property": property,
      "property_type": propertyType,
      "quantity": variantQuantity,
      "image": variantImageLink ?? "",
      "price": variantPrice,
    };
  }

  MapData toOrderDataFormat({
    required ProductEntities entity,
    int? quantities,
  }) {
    return {
      "id": entity.id,
      "quantity": quantities ?? 1,
      "unit_price": entity.sellingPrice,
      "product_name": entity.name,
      "purchase_price": entity.purchasePrice,
      "shop_id": entity.shopId,
    };
  }

  MapData toPackCompositionFormat({required ProductEntities entity}) {
    return {
      'id': entity.id,
      'quantity': entity.quantity,
      'purchase_price': entity.purchasePrice,
      'selling_price': entity.sellingPrice,
      'image': entity.images,
      'name': entity.name,
      'shop_id': entity.shopId,
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    eId,
    createdAt,
    name,
    quantity,
    description,
    type,
    variant,
    images,
    purchasePrice,
    sellingPrice,
    futureProduct,
    isPack,
    packComposition,
    shopId,
  ];
}
