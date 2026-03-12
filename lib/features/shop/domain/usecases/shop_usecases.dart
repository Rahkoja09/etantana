import 'dart:io';

import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:e_tantana/features/shop/domain/repository/shop_repository.dart';
import 'package:e_tantana/shared/media/media_services.dart';

class ShopUsecases {
  final ShopRepository _repo;
  final MediaServices _mediaServices;

  ShopUsecases(this._repo, this._mediaServices);

  /// Exécute l'insertion d'un nouveau Shop
  ResultFuture<ShopEntity> insertShop(
    ShopEntity entity,
    File shopImage,
    String userId,
  ) async {
    final shopProfilUrl = await _mediaServices.uploadMedia(
      file: shopImage,
      uid: userId,
      type: AppMediaType.shop,
      internalPath: "profil",
      bucketName: "shop",
    );
    final newShopEntity = entity.copyWith(
      shopLogo: shopProfilUrl,
      userId: userId,
    );

    return await _repo.createShopAndUpdateUser(newShopEntity);
  }

  /// Exécute la mise à jour d'un Shop
  ResultFuture<ShopEntity> updateShop(ShopEntity entity) async {
    return await _repo.updateShop(entity);
  }

  /// Exécute la suppression d'un Shop par son identifiant
  ResultVoid deleteShopById(String id) async {
    return await _repo.deleteShopById(id);
  }

  /// Récupère un Shop spécifique
  ResultFuture<ShopEntity> getShopById(String id) async {
    return await _repo.getShopById(id);
  }

  /// Effectue une recherche de Shop avec pagination
  ResultFuture<List<ShopEntity>> searchShop({
    ShopEntity? criteria,
    int start = 0,
    int end = 9,
  }) async {
    return await _repo.searchShop(criteria: criteria, start: start, end: end);
  }
}
