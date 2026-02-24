import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:equatable/equatable.dart';

class ProductListState extends Equatable {
  final bool checkboxInList;
  final bool isOrdering;
  final List<MapData>? productDataListToOrder;
  final List<ProductEntities>? productEntititesToOrder;
  final List<MapData>? packComposition;
  final String? productNameToSearch;
  final ProductEntities? selectedProduct;
  final bool isSelectePackProducts;

  ProductListState({
    this.checkboxInList = false,
    this.isOrdering = false,
    this.isSelectePackProducts = false,
    this.packComposition,
    this.productDataListToOrder = const [],
    this.productEntititesToOrder = const [],
    this.productNameToSearch,
    this.selectedProduct,
  });

  ProductListState copyWith({
    bool? checkboxInList,
    List<MapData>? productDataListToOrder,
    List<ProductEntities>? productEntititesToOrder,
    List<MapData>? packComposition,
    String? productNameToSearch,
    ProductEntities? selectedProduct,
    bool? isSelectePackProducts,
    bool? isOrdering,
  }) {
    return ProductListState(
      isSelectePackProducts:
          isSelectePackProducts ?? this.isSelectePackProducts,
      packComposition: packComposition ?? this.packComposition,
      productDataListToOrder:
          productDataListToOrder ?? this.productDataListToOrder,
      productEntititesToOrder:
          productEntititesToOrder ?? this.productEntititesToOrder,
      productNameToSearch: productNameToSearch ?? this.productNameToSearch,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      isOrdering: isOrdering ?? this.isOrdering,
      checkboxInList: checkboxInList ?? this.checkboxInList,
    );
  }

  @override
  List<Object?> get props => [
    isSelectePackProducts,
    packComposition,
    productDataListToOrder,
    productEntititesToOrder,
    productNameToSearch,
    selectedProduct,
    isOrdering,
    checkboxInList,
  ];
}
