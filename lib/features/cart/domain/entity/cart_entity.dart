import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String? id;
  final DateTime? createdAt;
  // [FIELDS_ANCHOR]

  const CartEntity({
    this.id,
    this.createdAt,
    // [CONSTRUCTOR_ANCHOR]
  });

  CartEntity copyWith({
    String? id,
    DateTime? createdAt,
    // [COPYWITH_PARAMS_ANCHOR]
  }) {
    return CartEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      // [COPYWITH_RETURN_ANCHOR]
    );
  }

  @override
  List<Object?> get props => [
    id, 
    createdAt,
    // [PROPS_ANCHOR]
  ];
}