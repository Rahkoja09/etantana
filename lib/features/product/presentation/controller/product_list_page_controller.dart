import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/states/product_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListPageController extends StateNotifier<ProductListState> {
  ProductListPageController() : super(ProductListState());

  void togglePackSelection() {
    state = state.copyWith(isSelectePackProducts: !state.isSelectePackProducts);
  }

  void selectedProduct(ProductEntities product) {
    state = state.copyWith(selectedProduct: product);
  }

  void putProductNameTosearch(String productName) {
    state = state.copyWith(productNameToSearch: productName);
  }

  void setPackComposition(List<MapData> packComposition) {
    state = state.copyWith(packComposition: packComposition);
  }

  void setProductEntitiesToOrder(
    List<ProductEntities> productEntititesToOrder,
  ) {
    state = state.copyWith(productEntititesToOrder: productEntititesToOrder);
  }

  void setProductDataToOrder(List<MapData> productDataListToOrder) {
    state = state.copyWith(productDataListToOrder: productDataListToOrder);
  }
}

final productListPageControllerProvider =
    StateNotifierProvider<ProductListPageController, ProductListState>((ref) {
      return ProductListPageController();
    });
