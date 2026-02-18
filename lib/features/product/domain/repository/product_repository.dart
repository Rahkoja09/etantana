import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';

abstract class ProductRepository {
  ResultFuture<ProductEntities> insertProduct(ProductEntities entities);
  ResultFuture<ProductEntities> updateProduct(ProductEntities entities);
  ResultVoid deleteProductById(String productId);
  ResultFuture<ProductEntities> getProductById(String productId);
  ResultVoid cancelAndRestock(String orderId);
  ResultFuture<List<ProductEntities>> researchProduct(
    ProductEntities? criterial, {
    int start = 0,
    int end = 9,
  });
}
