import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';

class ProductModel extends ProductEntities {
  const ProductModel({
    super.name,
    super.quantity,
    super.createdAt,
    super.eId,
    super.details,
    super.description,
    super.id,
    super.images,
    super.type,
    super.purchasePrice,
    super.sellingPrice,
    super.futureProduct,
    super.isPack,
    super.packComposition,
  });

  factory ProductModel.fromMap(MapData data) {
    return ProductModel(
      id: data['id'],
      name: data['name'],
      quantity: data["quantity"],
      createdAt: DateTime.parse(data['created_at']),
      description: data['description'],
      details: data['details'],
      eId: data['e_id'],
      images: data['images'],
      type: data['type'],
      purchasePrice: data['purchase_price'].toDouble(),
      sellingPrice: data['selling_price'].toDouble(),
      futureProduct: data["future_product"],
      packComposition:
          data['pack_composition'] != null
              ? (data['pack_composition'] as List)
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList()
              : null,
      isPack: data['is_pack'],
    );
  }

  MapData toMap() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'name': name,
      'quantity': quantity,
      'description': description,
      'type': type,
      'details': details,
      'images': images,
      'e_id': eId,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      "future_product": futureProduct,
      'is_pack': isPack,
      'pack_composition': packComposition,
    };
  }

  factory ProductModel.fromEntity(ProductEntities entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      quantity: entity.quantity,
      createdAt: entity.createdAt,
      description: entity.description,
      details: entity.details,
      eId: entity.eId,
      images: entity.images,
      type: entity.type,
      purchasePrice: entity.purchasePrice,
      sellingPrice: entity.sellingPrice,
      futureProduct: entity.futureProduct,
      isPack: entity.isPack,
      packComposition: entity.packComposition,
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    int? quantity,
    DateTime? createdAt,
    String? description,
    String? details,
    String? images,
    String? type,
    String? eId,
    double? purchasePrice,
    double? sellingPrice,
    bool? futureProduct,
    bool? isPack,
    List<MapData>? packComposition,
  }) {
    return ProductModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      details: details ?? this.details,
      eId: eId ?? this.eId,
      id: id ?? this.id,
      images: images ?? this.images,
      type: type ?? this.type,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      futureProduct: futureProduct ?? this.futureProduct,
      isPack: isPack ?? this.isPack,
      packComposition: packComposition ?? this.packComposition,
    );
  }
}
