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
    _setLoadingState();
    final res = await _productUsecases.insertProduct(entities, productImage);
    res.fold((error) => _setError(error), (success) {
      state = state.copyWith(
        isLoading: false,
        product: [success, ...?state.product],
      );
    });
  }

  Future<void> updateProduct(ProductEntities entities) async {
    _setLoadingState();
    final res = await _productUsecases.updateProduct(entities);
    res.fold((error) => _setError(error), (updatedProduct) {
      final newList =
          state.product
              ?.map((p) => p.id == updatedProduct.id ? updatedProduct : p)
              .toList() ??
          [];
      state = state.copyWith(isLoading: false, product: newList);
    });
  }

  Future<void> deleteProductById(String productId) async {
    _setLoadingState();
    final res = await _productUsecases.deleteProductById(productId);
    res.fold((error) => _setError(error), (success) {
      final newList =
          state.product?.where((p) => p.id != productId).toList() ?? [];
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
    _currentPage = 0;
    _isLastPage = false;

    _setLoadingState();

    // On mémorise les critères dans le state --------------------------<<
    state = state.copyWith(currentCriteria: criterial);

    // On demande les index 0 à 9 ---------
    final res = await _productUsecases.researchProduct(
      state.currentCriteria,
      start: 0,
      end: _pageSize - 1,
    );

    res.fold((error) => _setError(error), (success) {
      if (success.length < _pageSize) _isLastPage = true;
      state = state.copyWith(
        isLoading: false,
        isClearError: true,
        product: success,
      );
    });
  }

  // page suivante du lazy loading ------
  Future<void> loadNextPage(ProductEntities? criterial) async {
    if (state.isLoading || _isLastPage) return;

    _currentPage++;
    final int start = _currentPage * _pageSize;
    final int end = start + _pageSize - 1;

    final res = await _productUsecases.researchProduct(
      state.currentCriteria,
      start: start,
      end: end,
    );

    res.fold((error) => _setError(error), (newProducts) {
      if (newProducts.isEmpty) {
        _isLastPage = true;
      } else {
        if (newProducts.length < _pageSize) _isLastPage = true;

        state = state.copyWith(
          isLoading: false,
          product: [...?state.product, ...newProducts],
        );
      }
    });
  }

  void updateCriterial(ProductEntities updateCriterial) {
    state = state.copyWith(currentCriteria: updateCriterial);
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
