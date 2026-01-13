import 'package:e_tantana/features/product/data/model/product_model.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';

abstract class ProductDataSource {
  Future<ProductModel> insertProduct(ProductEntities entities);
  Future<ProductModel> updateProduct(ProductEntities entities);
  Future<void> deleteProductById(String productId);
  Future<ProductModel> getProductById(String productId);
  Future<List<ProductModel>> researchProduct(ProductEntities? criterial);
}
