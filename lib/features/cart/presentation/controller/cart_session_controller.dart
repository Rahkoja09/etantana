import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:e_tantana/features/cart/presentation/states/cart_session_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSessionController extends StateNotifier<CartSessionState> {
  CartSessionController() : super(const CartSessionState());

  // ── Ajouter ──────────────────────────────────────────────
  void addItem(CartEntity item) {
    final existing = _findIndex(item.productId, item.chosenVariant?['name']);

    if (existing >= 0) {
      // Déjà dans le panier — incrémenter
      _updateAt(
        existing,
        (old) =>
            old.copyWith(quantity: (old.quantity ?? 0) + (item.quantity ?? 1)),
      );
    } else {
      state = state.copyWith(carts: [...?state.carts, item]);
    }
  }

  // ── Retirer ──────────────────────────────────────────────
  void removeItem(String? productId, {String? variantName}) {
    state = state.copyWith(
      carts:
          state.carts
              ?.where(
                (e) =>
                    !(e.productId == productId &&
                        e.chosenVariant?['name'] == variantName),
              )
              .toList(),
    );
  }

  // ── Modifier quantité ────────────────────────────────────
  void updateQuantity(String? productId, int quantity, {String? variantName}) {
    if (quantity <= 0) {
      removeItem(productId, variantName: variantName);
      return;
    }
    final index = _findIndex(productId, variantName);
    if (index >= 0) {
      _updateAt(index, (old) => old.copyWith(quantity: quantity));
    }
  }

  // ── Vider ────────────────────────────────────────────────
  void clear() => state = const CartSessionState();

  // ── Helpers internes ─────────────────────────────────────
  int _findIndex(String? productId, String? variantName) {
    return state.carts?.indexWhere(
          (e) =>
              e.productId == productId &&
              e.chosenVariant?['name'] == variantName,
        ) ??
        -1;
  }

  void _updateAt(int index, CartEntity Function(CartEntity) update) {
    final updated = List<CartEntity>.from(state.carts!);
    updated[index] = update(updated[index]);
    state = state.copyWith(carts: updated);
  }
}

// ── Provider ─────────────────────────────────────────────────
final cartSessionProvider =
    StateNotifierProvider<CartSessionController, CartSessionState>((ref) {
      return CartSessionController();
    });
