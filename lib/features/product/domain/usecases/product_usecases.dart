import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/enums/order_status.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductUsecases {
  final ProductRepository _productRepository;
  final MediaServices _mediaServices;
  ProductUsecases(this._productRepository, this._mediaServices);

  ResultFuture<ProductEntities> insertProduct(
    ProductEntities entities,
    File? productImage,
  ) async {
    try {
      String imageLink = "";
      if (productImage != null) {
        _mediaServices.validateMedia(productImage, AppMediaType.product);
        imageLink = await _mediaServices.uploadMedia(
          file: productImage,
          uid: "products_images",
          type: AppMediaType.product,
          bucketName: "product",
        );

        final entitiesWithImageLink = entities.copyWith(images: imageLink);
        return _productRepository.insertProduct(entitiesWithImageLink);
      }
      return _productRepository.insertProduct(entities);
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
