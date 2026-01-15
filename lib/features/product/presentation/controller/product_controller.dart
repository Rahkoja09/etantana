import 'dart:io';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/usecases/product_usecases.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductController extends StateNotifier<ProductState> {
  final ProductUsecases _productUsecases;
  ProductController(this._productUsecases) : super(ProductState());

  Future<void> addProduct(ProductEntities entities, File? productImage) async {
    _setLoadingState();
    final res = await _productUsecases.insertProduct(entities, productImage);
    res.fold((error) => _setError(error), (success) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        errorMessage: null,
        product: [success, ...?state.product],
      );
    });
  }

  Future<void> updateProduct(ProductEntities entities) async {
    _setLoadingState();
    final res = await _productUsecases.updateProduct(entities);

    res.fold((error) => _setError(error), (updatedProduct) {
      final List<ProductEntities> currentProducts = state.product ?? [];
      final newProductList =
          currentProducts.map<ProductEntities>((p) {
            return p.id == updatedProduct.id ? updatedProduct : p;
          }).toList();

      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        product: newProductList,
      );
    });
  }

  Future<void> deleteProductById(String productId) async {
    _setLoadingState();
    final res = await _productUsecases.deleteProductById(productId);

    res.fold((error) => _setError(error), (success) {
      final newList = state.product!.where((p) => p.id != productId).toList();
      state = state.copyWith(isLoading: false, product: newList);
    });
  }

  Future<void> getProductById(String productId) async {
    _setLoadingState();
    final res = await _productUsecases.getProductById(productId);

    res.fold((error) => _setError(error), (success) {
      final otherProducts =
          state.product?.where((p) => p.id != success.id).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        product: [success, ...otherProducts],
      );
    });
  }

  Future<void> researchProduct(ProductEntities? criterial) async {
    _setLoadingState();
    final res = await _productUsecases.researchProduct(criterial);
    res.fold((error) => _setError(error), (success) {
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        errorMessage: null,
        product: success,
      );
    });
  }

  // set loading state ----------
  void _setLoadingState() {
    state = state.copyWith(isLoading: true);
  }

  void _setError(Failure error) {
    state = state.copyWith(
      isLoading: false,
      isClearError: false,
      errorMessage: error.message,
    );
  }
}

final productControllerProvider =
    StateNotifierProvider<ProductController, ProductState>((ref) {
      final productUsecases = sl<ProductUsecases>();
      return ProductController(productUsecases);
    });
