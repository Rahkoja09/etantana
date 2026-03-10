import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';

abstract class ShopRepository {
  /// Insère un nouveau Shop
  ResultFuture<ShopEntity> insertShop(ShopEntity entity);

  /// Met à jour un Shop existant
  ResultFuture<ShopEntity> updateShop(ShopEntity entity);

  /// Recherche des Shops selon des critères avec pagination
  ResultFuture<List<ShopEntity>> searchShop({
    ShopEntity? criteria,
    int start = 0,
    int end = 9,
  });

  /// Récupère un Shop spécifique par son ID
  ResultFuture<ShopEntity> getShopById(String id);

  /// Supprime un Shop définitivement
  ResultVoid deleteShopById(String id);
}