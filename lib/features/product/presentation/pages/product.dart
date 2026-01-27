import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/order/presentation/pages/add_order.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/pages/add_product.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/features/product/presentation/widgets/minimal_product_view.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/confirmation_dialogue.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:e_tantana/shared/widget/popup/transparent_background_pop_up.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<ProductEntities> myProducts = [];
  bool isFetching = false;
  bool showPopUp = false;
  ProductEntities? selectionForActionProduct;

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
    ref.listen<ProductState>(productControllerProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        showToast(
          context,
          title: 'Erreur de récuperation produit.',
          isError: true,
          description: next.errorMessage!,
        );
      }
      if (next.product != null && next.isLoading == false) {
        myProducts = next.product!;
      }
    });

    final skeletonData = List.generate(
      5,
      (index) => ProductEntities(name: "Chargement...", quantity: 1),
    );

    final isInitialLoading = productState.isLoading && myProducts.isEmpty;
    final displayList = isInitialLoading ? skeletonData : myProducts;

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(StylesConstants.spacerContent),
                  child: FloatingSearchBar(
                    controller: _searchController,
                    onSortTap: () {},
                    hintText: "Rechercher un produit (par son nom)",
                    onChanged: (val) {
                      ref
                          .read(productControllerProvider.notifier)
                          .researchProduct(ProductEntities(name: val));
                    },
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
                              child: ListView.builder(
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
                                  return MinimalProductView(
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
                                      });
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (_) => AddOrder(
                                                productToOrder:
                                                    selectionForActionProduct,
                                              ),
                                        ),
                                      );
                                    },
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
                await getProduct();
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
