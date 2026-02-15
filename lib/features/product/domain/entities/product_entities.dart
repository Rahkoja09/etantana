import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:equatable/equatable.dart';

class ProductEntities extends Equatable {
  final String? id;
  final String? eId;
  final DateTime? createdAt;
  final String? name;
  final int? quantity;
  final String? description;
  final String? type;
  final String? details;
  final String? images;
  final double? purchasePrice;
  final double? sellingPrice;
  final bool? futureProduct;
  final bool? isPack;
  final List<MapData>? packComposition;

  const ProductEntities({
    this.id,
    this.createdAt,
    this.eId,
    this.name,
    this.quantity,
    this.description,
    this.details,
    this.images,
    this.type,
    this.purchasePrice,
    this.sellingPrice,
    this.futureProduct,
    this.isPack = false,
    this.packComposition,
  });

  ProductEntities copyWith({
    String? id,
    String? eId,
    DateTime? createdAt,
    String? name,
    int? quantity,
    String? description,
    String? type,
    String? details,
    String? images,
    double? purchasePrice,
    double? sellingPrice,
    bool? futureProduct,
    bool? isPack,
    List<MapData>? packComposition,
  }) {
    return ProductEntities(
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

  @override
  List<Object?> get props => [
    id,
    eId,
    createdAt,
    name,
    quantity,
    description,
    type,
    details,
    images,
    purchasePrice,
    sellingPrice,
    futureProduct,
    isPack,
    packComposition,
  ];
}
