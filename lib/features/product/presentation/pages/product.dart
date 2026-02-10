import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/core/utils/tools/calculate_total_product.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/presentation/pages/add_order.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/pages/add_product.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/features/product/presentation/widgets/minimal_product_view.dart';
import 'package:e_tantana/features/product/presentation/widgets/order_summary_floating_bar.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/confirmation_dialogue.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:e_tantana/shared/widget/popup/transparent_background_pop_up.dart';
import 'package:e_tantana/shared/widget/selectableOption/flat_chip_selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Product extends ConsumerStatefulWidget {
  const Product({super.key});

  @override
  ConsumerState<Product> createState() => _ProductState();
}

class _ProductState extends ConsumerState<Product> {
  final ScrollController _scrollController = ScrollController();
  int listVersion = 0;
  bool isFetching = false;

  // les input ---------
  final TextEditingController _searchController = TextEditingController();

  List<ProductEntities> myProducts = [];

  bool showPopUp = false;
  ProductEntities? selectionForActionProduct;
  String currentFilter = "Tous";

  // list des commandes - cmd multiple ---------
  List<MapData> orderList = [];
  List<ProductEntities> productsToOrde = [];

  // list des critères ---------
  List<String> criterialListSort = ["Tous", "Futurs produits", "Stock zéro"];

  // criterial variable -----------
  String? productNameCriterial;
  ProductEntities? criteriales;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getProduct();
    });
  }

  // multiple order actions --------
  void handleRestore() {
    setState(() {
      orderList.clear();
      productsToOrde.clear();
      listVersion++;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (!ref.read(productControllerProvider).isLoading) {
        setState(() => _currentPage++);
        setState(() {
          isFetching = false;
        });
        ref.read(productControllerProvider.notifier).loadNextPage(null);
        setState(() {
          isFetching = false;
        });
      }
    }
  }

  Future<void> getProduct() async {
    setState(() => _currentPage = 0);
    await ref.read(productControllerProvider.notifier).researchProduct(null);
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productControllerProvider);
    // la list des produit principale --------
    final actualProducts = productState.product ?? [];

    final skeletonData = List.generate(
      5,
      (index) => ProductEntities(
        name: "Chargement...",
        quantity: 1,
        createdAt: DateTime.now(),
      ),
    );
    final isInitialLoading = productState.isLoading && actualProducts.isEmpty;
    final displayList = isInitialLoading ? skeletonData : actualProducts;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (orderList.isNotEmpty)
                  OrderSummaryFloatingBar(
                    itemCount: orderList.length,
                    onCancel: () {
                      handleRestore();
                    },
                    onRestore: () {},
                    onValidate: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => AddOrder(
                                productToOrder: productsToOrde,
                                orderListToOrderWithQuantity: orderList,
                              ),
                        ),
                      );
                    },
                    totalAmount: calculateTotal(actualProducts, orderList),
                  ),
                if (!orderList.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(StylesConstants.spacerContent),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FloatingSearchBar(
                          controller: _searchController,
                          onSortTap: () {},
                          hintText: "Rechercher un produit (par son nom)",
                          onChanged: (val) {
                            ref
                                .read(productControllerProvider.notifier)
                                .researchProduct(ProductEntities(name: val));
                          },
                        ),
                        SizedBox(height: StylesConstants.spacerContent),
                        FlatChipSelector(
                          options: criterialListSort,
                          selectedOption: currentFilter,
                          onSelect: (value) async {
                            setState(() => currentFilter = value);
                            switch (value) {
                              case ("Tous"):
                                {
                                  await getProduct();
                                  break;
                                }
                              case ("Futurs produits"):
                                {
                                  ref
                                      .read(productControllerProvider.notifier)
                                      .researchProduct(
                                        ProductEntities(futureProduct: true),
                                      );
                                  break;
                                }
                              case ("Stock zéro"):
                                {
                                  ref
                                      .read(productControllerProvider.notifier)
                                      .researchProduct(
                                        ProductEntities(quantity: 0),
                                      );
                                  break;
                                }
                              default:
                                {
                                  await getProduct();
                                  break;
                                }
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: AppRefreshIndicator(
                    onRefresh: getProduct,
                    child:
                        (displayList.isEmpty && !productState.isLoading)
                            ? _buildEmptyState()
                            : Skeletonizer(
                              enabled: productState.isLoading,
                              effect: LoadingEffect.getCommonEffect(context),
                              ignoreContainers: true,
                              child: ListView.builder(
                                key: ValueKey(listVersion),
                                controller:
                                    isInitialLoading ? null : _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                dragStartBehavior: DragStartBehavior.down,
                                padding: EdgeInsets.all(
                                  StylesConstants.spacerContent,
                                ),
                                itemCount:
                                    displayList.length +
                                    (productState.isLoading &&
                                            myProducts.isNotEmpty
                                        ? 1
                                        : 0),
                                itemBuilder: (context, index) {
                                  if (index == displayList.length &&
                                      isFetching) {
                                    return Skeletonizer(
                                      enabled: true,
                                      effect: LoadingEffect.getCommonEffect(
                                        context,
                                      ),
                                      child: MinimalProductView(
                                        selectedQuantity: (quantity) {},
                                        index: 0,
                                        onDelete: () {},
                                        product: displayList[0],
                                        onEdit: () {},
                                        onOrder: () {},
                                      ),
                                    );
                                  }
                                  if (index >= displayList.length) {
                                    return const SizedBox.shrink();
                                  }

                                  final item = displayList[index];
                                  return Column(
                                    children: [
                                      MinimalProductView(
                                        isSelected:
                                            orderList.indexWhere(
                                                      (element) =>
                                                          element["id"] ==
                                                          item.id,
                                                    ) !=
                                                    -1
                                                ? true
                                                : false,
                                        selectedQuantity: (quantity) {
                                          final index = orderList.indexWhere(
                                            (element) =>
                                                element["id"] == item.id,
                                          );

                                          if (quantity > 0) {
                                            if (index != -1) {
                                              orderList[index]["quantity"] =
                                                  quantity;
                                            } else {
                                              orderList.add({
                                                "id": item.id,
                                                "quantity": quantity,
                                                "unit_price": item.sellingPrice,
                                                "product_name": item.name,
                                                "purchase_price":
                                                    item.purchasePrice,
                                              });
                                            }
                                          } else {
                                            if (index != -1) {
                                              orderList.removeAt(index);
                                            }
                                          }

                                          setState(() {});
                                        },
                                        index: index + 1,
                                        onDelete: () {
                                          setState(() {
                                            showPopUp = true;
                                          });
                                          setState(() {
                                            selectionForActionProduct = item;
                                          });
                                        },
                                        product: item,
                                        onEdit: () {
                                          setState(() {
                                            selectionForActionProduct = item;
                                          });
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => AddProduct(
                                                    isFutureProduct: false,
                                                    productToEdit:
                                                        selectionForActionProduct,
                                                  ),
                                            ),
                                          );
                                        },
                                        onOrder: () {
                                          setState(() {
                                            selectionForActionProduct = item;
                                            orderList.add({
                                              "id": item.id,
                                              "quantity": 1,
                                              "unit_price": item.sellingPrice,
                                              "product_name": item.name,
                                              "purchase_price":
                                                  item.purchasePrice,
                                            });
                                          });
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => AddOrder(
                                                    orderListToOrderWithQuantity:
                                                        orderList,
                                                    productToOrder: [
                                                      selectionForActionProduct,
                                                    ],
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  );
                                },
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (showPopUp)
          TransparentBackgroundPopUp(
            widget: ConfirmationDialogue(
              backGroundColor: Theme.of(context).colorScheme.surface,
              btnColor: null,
              isActionDangerous: true,
              title: "Vouler vous vraiment supprimer ce produit :",
              value: "${selectionForActionProduct!.name}",
              icon: HugeIcons.strokeRoundedDelete03,
              isloading: productState.isLoading,
              onTapLeftBtn: () {
                setState(() {
                  showPopUp = false;
                });
              },
              onTapRightBtn: () async {
                await ref
                    .read(productControllerProvider.notifier)
                    .deleteProductById(selectionForActionProduct!.id!);
                setState(() {
                  showPopUp = false;
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 60.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            const Text("Aucun produit en stock"),
          ],
        ),
      ),
    );
  }
}
