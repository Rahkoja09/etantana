import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:equatable/equatable.dart';

class CartSessionState extends Equatable {
  final List<CartEntity>? carts;

  const CartSessionState({this.carts});

  // ── Getters utiles pour l'UI ─────────────────────────────
  int get itemCount => carts?.length ?? 0;

  double get totalPrice =>
      carts?.fold(0, (sum, item) => sum! + item.totalPrice) ?? 0;

  bool get isEmpty => carts == null || carts!.isEmpty;

  CartSessionState copyWith({List<CartEntity>? carts}) {
    return CartSessionState(carts: carts ?? this.carts);
  }

  @override
  List<Object?> get props => [carts];
}
