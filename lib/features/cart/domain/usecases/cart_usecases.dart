import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:e_tantana/features/cart/domain/repository/cart_repository.dart';

class CartUsecases {
  final CartRepository _repo;

  CartUsecases(this._repo);

  /// Exécute l'insertion d'un nouveau Cart
  ResultFuture<CartEntity> insertCart(CartEntity entity) async {
    return await _repo.insertCart(entity);
  }

  /// Exécute la mise à jour d'un Cart
  ResultFuture<CartEntity> updateCart(CartEntity entity) async {
    return await _repo.updateCart(entity);
  }

  /// Exécute la suppression d'un Cart par son identifiant
  ResultVoid deleteCartById(String id) async {
    return await _repo.deleteCartById(id);
  }

  /// Récupère un Cart spécifique
  ResultFuture<CartEntity> getCartById(String id) async {
    return await _repo.getCartById(id);
  }

  /// Effectue une recherche de Cart avec pagination
  ResultFuture<List<CartEntity>> searchCart({
    CartEntity? criteria,
    int start = 0,
    int end = 9,
  }) async {
    return await _repo.searchCart(
      criteria: criteria,
      start: start,
      end: end,
    );
  }
}