import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';

abstract class CartRepository {
  /// Insère un nouveau Cart
  ResultFuture<CartEntity> insertCart(CartEntity entity);

  /// Met à jour un Cart existant
  ResultFuture<CartEntity> updateCart(CartEntity entity);

  /// Recherche des Carts selon des critères avec pagination
  ResultFuture<List<CartEntity>> searchCart({
    CartEntity? criteria,
    int start = 0,
    int end = 9,
  });

  /// Récupère un Cart spécifique par son ID
  ResultFuture<CartEntity> getCartById(String id);

  /// Supprime un Cart définitivement
  ResultVoid deleteCartById(String id);
}