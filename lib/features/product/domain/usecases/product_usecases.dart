import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';
import 'package:e_tantana/shared/media/media_services.dart';

class ProductUsecases {
  final ProductRepository _productRepository;
  final MediaServices _mediaServices;
  ProductUsecases(this._productRepository, this._mediaServices);

  ResultFuture<ProductEntities> insertProduct(
    ProductEntities entities,
    File? productImage,
    List<File?>? variantImages,
    String userId,
  ) async {
    try {
      String imageLink = "";
      List<String> variantImageLinks = [];

      if (variantImages != null && variantImages.isNotEmpty) {
        final nonNullImages = variantImages.whereType<File>().toList();

        if (nonNullImages.isNotEmpty) {
          variantImageLinks = await _mediaServices.uploadMultipleMedia(
            files: nonNullImages,
            type: AppMediaType.variantProduct,
            uid: entities.shopId!,
            bucketName: "product",
            internalPath: "variants",
          );
        }
      }

      // Mapper les liens dans les variants ----
      List<Map<String, dynamic>>? variantsWithImages;
      if (entities.variant != null && entities.variant!.isNotEmpty) {
        int uploadIndex = 0;
        variantsWithImages =
            entities.variant!.asMap().entries.map((entry) {
              final i = entry.key;
              final variant = Map<String, dynamic>.from(entry.value);

              // Si ce variant avait une nouvelle image uploadée ------
              final hasNewImage =
                  variantImages != null &&
                  i < variantImages.length &&
                  variantImages[i] != null;

              if (hasNewImage && uploadIndex < variantImageLinks.length) {
                variant['image'] = variantImageLinks[uploadIndex];
                uploadIndex++;
              }

              return variant;
            }).toList();
      }

      if (productImage != null) {
        _mediaServices.validateMedia(productImage, AppMediaType.product);
        imageLink = await _mediaServices.uploadMedia(
          file: productImage,
          uid: userId,
          type: AppMediaType.product,
          internalPath: entities.shopId,
          bucketName: "product",
        );
      }

      final entitiesWithLinks = entities.copyWith(
        images: imageLink.isNotEmpty ? imageLink : entities.images,
        userId: userId,
        variant: variantsWithImages ?? entities.variant,
      );

      return _productRepository.insertProduct(entitiesWithLinks);
    } catch (e) {
      return Left(UnexceptedFailure(e.toString(), "000"));
    }
  }

  ResultFuture<ProductEntities> updateProduct(ProductEntities entities) =>
      _productRepository.updateProduct(entities);

  ResultVoid cancelAndRestock(String orderId) async =>
      await _productRepository.cancelAndRestock(orderId);

  ResultVoid deleteProductById(String productId) =>
      _productRepository.deleteProductById(productId);
  ResultFuture<ProductEntities> getProductById(String productId) =>
      _productRepository.getProductById(productId);
  ResultFuture<List<ProductEntities>> researchProduct(
    ProductEntities? criterial, {
    int start = 0,
    int end = 9,
  }) => _productRepository.researchProduct(criterial, start: start, end: end);
}
