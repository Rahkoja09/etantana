import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/data/dataSource/product_data_source.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final NetworkInfo _networkInfo;
  final ProductDataSource _productDataSource;
  ProductRepositoryImpl(this._networkInfo, this._productDataSource);

  @override
  ResultVoid deleteProductById(String productId) async {
    return await _executeAction<void>(
      () => _productDataSource.deleteProductById(productId),
    );
  }

  @override
  ResultFuture<ProductEntities> getProductById(String productId) async {
    return await _executeAction<ProductEntities>(
      () => _productDataSource.getProductById(productId),
    );
  }

  @override
  ResultFuture<ProductEntities> insertProduct(ProductEntities entities) async {
    return await _executeAction<ProductEntities>(
      () => _productDataSource.insertProduct(entities),
    );
  }

  @override
  ResultFuture<List<ProductEntities>> researchProduct(
    ProductEntities? criterial, {
    int start = 0,
    int end = 9,
  }) async {
    return await _executeAction<List<ProductEntities>>(
      () =>
          _productDataSource.researchProduct(criterial, start: start, end: end),
      isCritical: false,
    );
  }

  @override
  ResultFuture<ProductEntities> updateProduct(ProductEntities entities) async {
    return await _executeAction<ProductEntities>(
      () => _productDataSource.updateProduct(entities),
    );
  }

  @override
  ResultVoid cancelAndRestock(String orderId) async {
    return await _executeAction(
      () => _productDataSource.cancelAndRestock(orderId),
    );
  }

  ResultFuture<T> _executeAction<T>(
    Future<T> Function() action, {
    bool isCritical = true,
  }) async {
    final bool connected =
        isCritical
            ? await _networkInfo.isConnected
            : await _networkInfo.hasConnection;

    if (connected) {
      try {
        final res = await action();
        return Right(res);
      } on ApiException catch (e) {
        return Left(ApiFailure.fromException(e));
      } on AuthUserException catch (e) {
        return Left(AuthFailure.fromException(e));
      } catch (e) {
        return Left(UnexceptedFailure(e.toString(), "000"));
      }
    }
    return const Left(
      NetworkFailure("Pas de connexion internet", "Network_01"),
    );
  }
}
