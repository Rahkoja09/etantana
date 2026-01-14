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
  ];
}
