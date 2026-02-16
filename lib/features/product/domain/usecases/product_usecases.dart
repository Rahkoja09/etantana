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

  // xxxxx piramide de la mort, à refaire avec un rpc postgress xxxx --------------
  ResultVoid restoreProductQtyByStatus(List<MapData> orderList) async {
    try {
      for (var orderItem in orderList) {
        final String productId = orderItem["id"];
        final int qtyToRestore =
            int.tryParse(orderItem["quantity"].toString()) ?? 0;

        final productRes = await _productRepository.getProductById(productId);

        await productRes.fold((failure) async => Left(failure), (
          product,
        ) async {
          await _updateStockRestore(product, qtyToRestore);

          if (product.isPack == true && product.packComposition != null) {
            final List<dynamic> components =
                product.packComposition as List<dynamic>;

            for (var component in components) {
              final String compId = component["id"];

              const int qtyToRestorePerPack = 1;
              final int totalToRestoreForComponent =
                  qtyToRestorePerPack * qtyToRestore;

              final compRes = await _productRepository.getProductById(compId);

              await compRes.fold((error) => null, (compProduct) async {
                await _updateStockRestore(
                  compProduct,
                  totalToRestoreForComponent,
                );
              });
            }
          }
        });
      }
      return const Right(null);
    } catch (e) {
      return Left(UnexceptedFailure(e.toString(), "500"));
    }
  }

  Future<void> _updateStockRestore(
    ProductEntities product,
    int quantityToAdd,
  ) async {
    final currentQty = product.quantity ?? 0;
    final newQuantity = currentQty + quantityToAdd;
    final update = product.copyWith(quantity: newQuantity);
    await _productRepository.updateProduct(update);
  }

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
