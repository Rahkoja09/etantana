import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/states/product_list_state.dart';

class ProductListPageController extends StateNotifier<ProductListState> {
  ProductListPageController() : super(ProductListState());
  void toggleCheckBox() {
    state = state.copyWith(checkboxInList: !state.checkboxInList);
  }

  void emptyProductDataToOrder() {
    state = state.copyWith(productDataListToOrder: []);
    state = state.copyWith(productEntititesToOrder: []);
  }

  void empltyPackComposition() {
    state = state.copyWith(packComposition: []);
  }

  void togglePackSelection() {
    state = state.copyWith(isSelectePackProducts: !state.isSelectePackProducts);
  }

  void selectedProduct(ProductEntities product) {
    state = state.copyWith(selectedProduct: product);
  }

  void putProductNameTosearch(String productName) {
    state = state.copyWith(productNameToSearch: productName);
  }

  void toggleProductInPack(ProductEntities entity, bool value) {
    final currentPack = state.packComposition ?? [];

    if (value == true) {
      final isAlreadyInPack = currentPack.any(
        (item) => item['id'] == entity.id,
      );

      if (!isAlreadyInPack) {
        final newItem = entity.toPackCompositionFormat(entity: entity);
        state = state.copyWith(packComposition: [...currentPack, newItem]);
      }
    } else {
      state = state.copyWith(
        packComposition:
            currentPack.where((item) => item['id'] != entity.id).toList(),
      );
    }
  }

  void updateProductOrder(ProductEntities item, int quantity) {
    final currentOrderList = state.productDataListToOrder ?? [];
    final currentEntities = state.productEntititesToOrder ?? [];
    if (quantity <= 0) {
      state = state.copyWith(
        productDataListToOrder:
            currentOrderList.where((e) => e['id'] != item.id).toList(),
        productEntititesToOrder:
            currentEntities.where((e) => e.id != item.id).toList(),
      );
      return;
    }
    final index = currentOrderList.indexWhere((e) => e['id'] == item.id);

    if (index != -1) {
      final updatedList =
          currentOrderList.map((e) {
            if (e['id'] == item.id) {
              return item.toOrderDataFormat(entity: item, quantities: quantity);
            }
            return e;
          }).toList();
      state = state.copyWith(productDataListToOrder: updatedList);
    } else {
      final newItemData = item.toOrderDataFormat(
        entity: item,
        quantities: quantity,
      );
      state = state.copyWith(
        productDataListToOrder: [...currentOrderList, newItemData],
        productEntititesToOrder: [...currentEntities, item],
      );
    }
  }
}

final productListPageControllerProvider =
    StateNotifierProvider<ProductListPageController, ProductListState>((ref) {
      return ProductListPageController();
    });
