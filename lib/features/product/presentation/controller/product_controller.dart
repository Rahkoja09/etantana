import 'dart:io';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/usecases/product_usecases.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductController extends StateNotifier<ProductState> {
  final ProductUsecases _productUsecases;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLastPage = false;

  ProductController(this._productUsecases) : super(ProductState());

  Future<void> addProduct(ProductEntities entities, File? productImage) async {
    final action = productAction.insertProduct;
    _setLoadingState(action: action);
    final res = await _productUsecases.insertProduct(entities, productImage);
    res.fold((error) => _setError(error: error, action: action), (success) {
      state = state.copyWith(
        isLoading: false,
        product: [success, ...?state.product],
        action: action,
      );
    });
  }

  Future<void> updateProduct(ProductEntities entities) async {
    final action = productAction.updateProduct;
    _setLoadingState(action: action);
    final res = await _productUsecases.updateProduct(entities);
    res.fold((error) => _setError(error: error, action: action), (
      updatedProduct,
    ) {
      final newList =
          state.product
              ?.map((p) => p.id == updatedProduct.id ? updatedProduct : p)
              .toList() ??
          [];
      state = state.copyWith(
        isLoading: false,
        product: newList,
        action: action,
      );
    });
  }

  Future<void> deleteProductById(String productId) async {
    final action = productAction.deleteProduct;
    _setLoadingState(action: action);
    final res = await _productUsecases.deleteProductById(productId);
    res.fold((error) => _setError(error: error, action: action), (success) {
      final newList =
          state.product?.where((p) => p.id != productId).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        product: newList,
        action: action,
      );
    });
  }

  Future<void> getProductById(String productId) async {
    final action = productAction.getProduct;
    _setLoadingState(action: action);
    final res = await _productUsecases.getProductById(productId);

    res.fold((error) => _setError(error: error, action: action), (success) {
      final otherProducts =
          state.product?.where((p) => p.id != success.id).toList() ?? [];
      state = state.copyWith(
        isLoading: false,
        product: [success, ...otherProducts],
        action: action,
      );
    });
  }

  Future<void> researchProduct(ProductEntities? criterial) async {
    final action = productAction.searchProduct;
    _currentPage = 0;
    _isLastPage = false;

    _setLoadingState(action: action);

    state = state.copyWith(
      currentCriteria: criterial,
      product: [],
      isLoading: true,
      action: action,
    );

    final res = await _productUsecases.researchProduct(
      criterial,
      start: 0,
      end: _pageSize - 1,
    );

    res.fold((error) => _setError(error: error, action: action), (success) {
      if (success.length < _pageSize) _isLastPage = true;
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        product: success,
        action: action,
      );
    });
  }

  // page suivante du lazy loading ------
  Future<void> loadNextPage(ProductEntities? criterial) async {
    final action = productAction.loadNextPage;
    if (state.isLoading || _isLastPage) return;

    _currentPage++;
    final int start = _currentPage * _pageSize;
    final int end = start + _pageSize - 1;

    final res = await _productUsecases.researchProduct(
      state.currentCriteria,
      start: start,
      end: end,
    );

    res.fold((error) => _setError(error: error, action: action), (newProducts) {
      if (newProducts.isEmpty) {
        _isLastPage = true;
      } else {
        if (newProducts.length < _pageSize) _isLastPage = true;

        state = state.copyWith(
          isLoading: false,
          product: [...?state.product, ...newProducts],
          action: action,
        );
      }
    });
  }

  void updateCriterial(ProductEntities updateCriterial) {
    state = state.copyWith(currentCriteria: updateCriterial);
  }

  // set loading state ----------
  void _setLoadingState({required productAction action}) {
    state = state.copyWith(isLoading: true, action: action);
  }

  void _setError({required Failure error, required productAction action}) {
    state = state.copyWith(
      isLoading: false,
      isClearError: false,
      error: error,
      action: action,
      errorCode: error.code,
    );
  }
}

final productControllerProvider =
    StateNotifierProvider<ProductController, ProductState>((ref) {
      final productUsecases = sl<ProductUsecases>();
      return ProductController(productUsecases);
    });
