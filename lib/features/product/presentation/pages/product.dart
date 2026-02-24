import 'dart:async';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/utils/tools/calculate_total_product.dart';
import 'package:e_tantana/features/order/presentation/pages/add_order.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/controller/product_list_page_controller.dart';
import 'package:e_tantana/features/product/presentation/pages/add_product.dart';
import 'package:e_tantana/features/product/presentation/pages/create_pack.dart';
import 'package:e_tantana/features/product/presentation/widgets/create_pack_summary_floating.dart';
import 'package:e_tantana/features/product/presentation/widgets/minimal_product_view.dart';
import 'package:e_tantana/features/product/presentation/widgets/order_summary_floating_bar.dart';
import 'package:e_tantana/shared/widget/dialogue/dialogue_delete_action.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/others/empty_content_view.dart';
import 'package:e_tantana/shared/widget/popup/show_custom_popup.dart';
import 'package:e_tantana/shared/widget/selectableOption/flat_chip_selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Timer? _debounce;
  bool isFetching = false;

  // les input ---------
  final TextEditingController _searchController = TextEditingController();

  List<ProductEntities> myProducts = [];

  String currentFilter = "Tous";

  // list des critères ---------
  List<String> criterialListSort = ["Tous", "Futurs produits", "Stock zéro"];

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
  void restoreOrderDataProducList() {
    listVersion++;
    ref
        .read(productListPageControllerProvider.notifier)
        .emptyProductDataToOrder();
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
    final ProductListPageState = ref.watch(productListPageControllerProvider);
    final ProductListPageAction = ref.read(
      productListPageControllerProvider.notifier,
    );
    // la list des produit principale --------------------
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ProductListPageState.packComposition != null &&
                    ProductListPageState.packComposition!.length > 0)
                  CreatePackSummaryFloating(
                    onCancel: () {
                      setState(() {
                        ProductListPageAction.toggleCheckBox();
                        ProductListPageAction.empltyPackComposition();
                      });
                    },
                    onValidate: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => CreatePack(
                                packComposition:
                                    ProductListPageState.packComposition!,
                              ),
                        ),
                      );
                    },
                    packCompositionLenght:
                        ProductListPageState.packComposition?.length ?? 0,
                  ),
                if (ProductListPageState.isOrdering)
                  OrderSummaryFloatingBar(
                    itemCount:
                        ProductListPageState.productDataListToOrder!.length,
                    onCancel: () {
                      restoreOrderDataProducList();
                    },
                    onRestore: () {},
                    onValidate: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => AddOrder(
                                productToOrder:
                                    ProductListPageState
                                        .productEntititesToOrder,
                                orderListToOrderWithQuantity:
                                    ProductListPageState
                                        .productDataListToOrder!,
                              ),
                        ),
                      );
                    },
                    totalAmount: calculateTotal(
                      actualProducts,
                      ProductListPageState.productDataListToOrder!,
                    ),
                  ),
                if (!ProductListPageState.isOrdering)
                  Container(
                    padding: EdgeInsets.all(StylesConstants.spacerContent),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FloatingSearchBar(
                          controller: _searchController,
                          onSortTap: () {},
                          hintText: "Rechercher un produit (par son nom)",
                          onChanged: (val) {
                            // On annule le lancement précédent si l'utilisateur tape une autre lettre
                            if (_debounce?.isActive ?? false)
                              _debounce!.cancel();

                            // On attend 500ms de silence avant de lancer la recherche
                            _debounce = Timer(
                              const Duration(milliseconds: 500),
                              () {
                                if (val.isNotEmpty) {
                                  ref
                                      .read(productControllerProvider.notifier)
                                      .researchProduct(
                                        ProductEntities(name: val),
                                      );
                                } else {
                                  // Si on efface tout, on recharge la liste de base (criterial = null)
                                  ref
                                      .read(productControllerProvider.notifier)
                                      .researchProduct(null);
                                }
                              },
                            );
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

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: StylesConstants.spacerContent,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Listes de produits",
                        style: TextStyles.titleSmall(
                          context: context,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ProductListPageAction.toggleCheckBox();
                        },
                        child: Icon(
                          HugeIcons.strokeRoundedCheckList,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.9),
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AppRefreshIndicator(
                    onRefresh: getProduct,
                    child:
                        (displayList.isEmpty && !productState.isLoading)
                            ? EmptyContentView(
                              icon: Icons.inventory_2_outlined,
                              text: "Aucun produit trouvé",
                            )
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
                                      child: Row(
                                        children: [
                                          MinimalProductView(
                                            selectedQuantity: (quantity) {},
                                            index: 0,
                                            onDelete: () {},
                                            product: displayList[0],
                                            onEdit: () {},
                                            onOrder: () {},
                                            onLongPress: () {},
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  if (index >= displayList.length) {
                                    return const SizedBox.shrink();
                                  }

                                  final item = displayList[index];
                                  // il faut assi séparer ca(checkbox et ses enfant) avec les autres (atomic) ------
                                  bool isThisProductSelected =
                                      ProductListPageState.packComposition !=
                                          null &&
                                      ProductListPageState.packComposition!.any(
                                        (element) => element['id'] == item.id,
                                      );

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          if (ProductListPageState
                                              .checkboxInList) ...[
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: Checkbox(
                                                value: isThisProductSelected,
                                                onChanged: (value) {
                                                  ProductListPageAction.toggleProductInPack(
                                                    item,
                                                    value!,
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                          ],

                                          Expanded(
                                            child: MinimalProductView(
                                              onLongPress: () {},

                                              selectedQuantity: (quantity) {
                                                ProductListPageAction.updateProductOrder(
                                                  item,
                                                  quantity,
                                                );
                                              },
                                              index: index + 1,
                                              onDelete: () {
                                                ProductListPageAction.selectedProduct(
                                                  item,
                                                );
                                                showCustomPopup(
                                                  context: context,
                                                  title: "Supprimer Produit",
                                                  isError: true,
                                                  dismissible: true,
                                                  isActionDangerous: true,
                                                  leftButtonTitle: "annuler",

                                                  onTapRightBtn: () async {
                                                    await ref
                                                        .read(
                                                          productControllerProvider
                                                              .notifier,
                                                        )
                                                        .deleteProductById(
                                                          ProductListPageState
                                                              .selectedProduct!
                                                              .id!,
                                                          productName:
                                                              ProductListPageState
                                                                  .selectedProduct!
                                                                  .name!,
                                                        );
                                                  },
                                                  child: DialogueDeleteAction(
                                                    nameOrID: "${item.name}",
                                                  ),

                                                  rightButtonTitle:
                                                      "supprimier",
                                                  description:
                                                      'Le produit sera définitivement supprimé.',
                                                );

                                                /*setState(() {
                                                  showPopUp = true;
                                                });
                                                */
                                              },
                                              product: item,
                                              onEdit: () {
                                                ProductListPageAction.selectedProduct(
                                                  item,
                                                );
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) => AddProduct(
                                                          isFutureProduct:
                                                              false,
                                                          productToEdit:
                                                              ProductListPageState
                                                                  .selectedProduct,
                                                        ),
                                                  ),
                                                );
                                              },
                                              onOrder: () {
                                                ProductListPageAction.selectedProduct(
                                                  item,
                                                );
                                                ProductListPageAction.selectedProduct(
                                                  item,
                                                );

                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) => AddOrder(
                                                          orderListToOrderWithQuantity:
                                                              ProductListPageState
                                                                  .productDataListToOrder,
                                                          productToOrder: [
                                                            ProductListPageState
                                                                .selectedProduct,
                                                          ],
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
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
      ],
    );
  }
}
