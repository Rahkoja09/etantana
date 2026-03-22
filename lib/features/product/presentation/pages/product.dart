import 'dart:async';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/cart/presentation/controller/cart_session_controller.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/controller/product_list_page_controller.dart';
import 'package:e_tantana/features/product/presentation/widgets/create_pack_summary_floating.dart';
import 'package:e_tantana/features/product/presentation/widgets/minimal_product_view.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String currentFilter = "Tous";
  List<String> criterialListSort = ["Tous", "Futurs produits", "Stock zéro"];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (!ref.read(productControllerProvider).isLoading) {
        setState(() => _currentPage++);
        ref.read(productControllerProvider.notifier).loadNextPage(null);
      }
    }
  }

  Future<void> getProduct() async {
    setState(() => _currentPage = 0);
    await ref
        .read(productListPageControllerProvider.notifier)
        .getAllProduct(ref);
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productControllerProvider);
    final productListPageState = ref.watch(productListPageControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final productListPageAction = ref.read(
      productListPageControllerProvider.notifier,
    );
    final cartState = ref.watch(cartSessionProvider);

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
                // ── Pack summary ─────────────────────────
                if (productListPageState.packComposition != null &&
                    productListPageState.packComposition!.isNotEmpty)
                  CreatePackSummaryFloating(
                    onCancel: () {
                      setState(() {
                        productListPageAction.toggleCheckBox();
                        productListPageAction.empltyPackComposition();
                      });
                    },
                    onValidate: () => context.push("/product/create-pack"),
                    packCompositionLenght:
                        productListPageState.packComposition?.length ?? 0,
                  ),

                // ── Search + filtres ──────────────────────
                Container(
                  padding: EdgeInsets.all(StylesConstants.spacerContent),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FloatingSearchBar(
                        controller: _searchController,
                        onSortTap: () {},
                        hintText: "Rechercher un produit",
                        onChanged: (val) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce = Timer(
                            const Duration(milliseconds: 500),
                            () {
                              ref
                                  .read(productControllerProvider.notifier)
                                  .researchProduct(
                                    val.isNotEmpty
                                        ? ProductEntities(
                                          name: val,
                                          userId: authState.user?.id,
                                        )
                                        : ProductEntities(
                                          userId: authState.user?.id,
                                        ),
                                  );
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
                            case "Tous":
                              await getProduct();
                              break;
                            case "Futurs produits":
                              ref
                                  .read(productControllerProvider.notifier)
                                  .researchProduct(
                                    ProductEntities(
                                      futureProduct: true,
                                      userId: authState.user?.id,
                                    ),
                                  );
                              break;
                            case "Stock zéro":
                              ref
                                  .read(productControllerProvider.notifier)
                                  .researchProduct(
                                    ProductEntities(
                                      quantity: 0,
                                      userId: authState.user?.id,
                                    ),
                                  );
                              break;
                            default:
                              await getProduct();
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // ── Header liste ──────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: StylesConstants.spacerContent,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Liste des produits",
                        style: TextStyles.bodyMedium(
                          context: context,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      InkWell(
                        onTap: productListPageAction.toggleCheckBox,
                        child: Icon(
                          productListPageState.checkboxInList
                              ? HugeIcons.strokeRoundedCheckmarkSquare01
                              : HugeIcons.strokeRoundedCheckList,
                          color:
                              productListPageState.checkboxInList
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.9),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Liste ─────────────────────────────────
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
                                padding: EdgeInsets.fromLTRB(
                                  StylesConstants.spacerContent,
                                  StylesConstants.spacerContent,
                                  StylesConstants.spacerContent,
                                  100.h, // espace pour le FAB panier
                                ),
                                itemCount: displayList.length,
                                itemBuilder: (context, index) {
                                  if (index >= displayList.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final item = displayList[index];
                                  final isThisProductSelected =
                                      productListPageState.packComposition !=
                                          null &&
                                      productListPageState.packComposition!.any(
                                        (e) => e['id'] == item.id,
                                      );

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          // Checkbox mode pack
                                          if (productListPageState
                                              .checkboxInList) ...[
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: Checkbox(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                value: isThisProductSelected,
                                                onChanged: (value) {
                                                  productListPageAction
                                                      .toggleProductInPack(
                                                        item,
                                                        value!,
                                                      );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                          ],

                                          Expanded(
                                            child: MinimalProductView(
                                              index: index + 1,
                                              product: item,
                                              // Mode manage si checkbox actif — sinon cart
                                              mode:
                                                  productListPageState
                                                          .checkboxInList
                                                      ? ProductViewMode.manage
                                                      : ProductViewMode.cart,
                                              onDelete: () {
                                                productListPageAction
                                                    .selectedProduct(item);
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
                                                          item.id!,
                                                          productName:
                                                              item.name!,
                                                        );
                                                    await ref
                                                        .read(
                                                          productControllerProvider
                                                              .notifier,
                                                        )
                                                        .researchProduct(
                                                          ProductEntities(
                                                            userId:
                                                                authState
                                                                    .user
                                                                    ?.id,
                                                          ),
                                                        );
                                                  },
                                                  child: DialogueDeleteAction(
                                                    nameOrID: "${item.name}",
                                                  ),
                                                  rightButtonTitle: "supprimer",
                                                  description:
                                                      'Le produit sera définitivement supprimé.',
                                                );
                                              },
                                              onEdit:
                                                  () => context.push(
                                                    "/product/add/false",
                                                    extra: item,
                                                  ),
                                              onLongPress: () {},
                                              selectedQuantity: (quantity) {
                                                productListPageAction
                                                    .updateProductOrder(
                                                      item,
                                                      quantity,
                                                    );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15.h),
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

        // ── FAB Panier ───────────────────────────────────
        if (!cartState.isEmpty)
          Positioned(
            bottom: 100.h,
            left: StylesConstants.spacerContent,
            right: StylesConstants.spacerContent,
            child: _CartFab(
              itemCount: cartState.itemCount,
              totalPrice: cartState.totalPrice,
              onTap: () => context.push('/cart'),
            ),
          ),
      ],
    );
  }
}

// ── Cart FAB ──────────────────────────────────────────────────

class _CartFab extends StatelessWidget {
  final int itemCount;
  final double totalPrice;
  final VoidCallback onTap;

  const _CartFab({
    required this.itemCount,
    required this.totalPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Badge count
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$itemCount article${itemCount > 1 ? 's' : ''}",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Voir le panier",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              "${totalPrice.toStringAsFixed(0)} Ar",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12.sp,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
