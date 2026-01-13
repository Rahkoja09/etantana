import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';

class ProductUsecases {
  final ProductRepository _productRepository;
  ProductUsecases(this._productRepository);

  ResultFuture<ProductEntities> insertProduct(ProductEntities entities) =>
      _productRepository.insertProduct(entities);
  ResultFuture<ProductEntities> updateProduct(ProductEntities entities) =>
      _productRepository.updateProduct(entities);
  ResultVoid deleteProductById(String productId) =>
      _productRepository.deleteProductById(productId);
  ResultFuture<ProductEntities> getProductById(String productId) =>
      _productRepository.getProductById(productId);
  ResultFuture<List<ProductEntities>> researchProduct(
    ProductEntities? criterial,
  ) => _productRepository.researchProduct(criterial);
}
