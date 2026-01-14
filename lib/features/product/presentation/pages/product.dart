import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/features/product/presentation/widgets/minimal_product_view.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/popup/custom_dialog.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
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
  List<ProductEntities> myProducts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getProduct();
    });
  }

  Future<void> getProduct() async {
    await ref.read(productControllerProvider.notifier).researchProduct(null);
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productControllerProvider);
    ref.listen<ProductState>(productControllerProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        showDialog(
          context: context,
          builder:
              (context) => ErrorDialog(
                title: "Erreur de récuperation produit.",
                message: next.errorMessage!,
              ),
        );
      }
      if (next.product != null && next.isLoading == false) {
        myProducts = next.product;
      }
    });
    final displayList =
        productState.isLoading
            ? List.generate(
              5,
              (index) => ProductEntities(name: "Chargement...", quantity: 0),
            )
            : myProducts;

    return Scaffold(
      body: AppRefreshIndicator(
        onRefresh: () async {
          await ref
              .read(productControllerProvider.notifier)
              .researchProduct(null);
        },
        child:
            (displayList.isEmpty && !productState.isLoading)
                ? _buildEmptyState()
                : Skeletonizer(
                  enabled: productState.isLoading,
                  effect: LoadingEffect.getCommonEffect(context),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(StylesConstants.spacerContent - 6),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
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
