import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:equatable/equatable.dart';

class ProductEntities extends Equatable {
  final String? id;
  final String? eId;
  final DateTime? createdAt;
  final String name;
  final int quantity;
  final String? description;
  final String? type;
  final String? details;
  final MapData? images;

  const ProductEntities({
    this.id,
    this.createdAt,
    this.eId,
    required this.name,
    required this.quantity,
    this.description,
    this.details,
    this.images,
    this.type,
  });

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
