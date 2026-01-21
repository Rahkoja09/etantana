import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/features/product/presentation/widgets/minimal_product_view.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/popup/custom_dialog.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    final displayList =
        myProducts.isEmpty
            ? List.generate(
              10,
              (index) => ProductEntities(name: "Chargement...", quantity: 1),
            )
            : myProducts;

    return Scaffold(
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
                            controller: _scrollController,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.all(
                              StylesConstants.spacerContent,
                            ),
                            itemCount:
                                displayList.length +
                                (productState.isLoading && myProducts.isNotEmpty
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index == displayList.length && isFetching) {
                                return Skeletonizer(
                                  enabled: true,
                                  effect: LoadingEffect.getCommonEffect(
                                    context,
                                  ),
                                  child: MinimalProductView(
                                    product: displayList[0],
                                    onEdit: () {},
                                    order: () {},
                                  ),
                                );
                              }
                              if (index >= displayList.length) {
                                return const SizedBox.shrink();
                              }

                              final item = displayList[index];
                              return MinimalProductView(
                                product: item,
                                onEdit: () {},
                                order: () {},
                              );
                            },
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 60.sp, color: Colors.grey),
          SizedBox(height: 16.h),
          const Text("Aucun produit en stock"),
        ],
      ),
    );
  }
}
