import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/shared/widget/input/custom_drop_down.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/custom_dialog.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SelectProduct extends ConsumerStatefulWidget {
  final ProductEntities? selectedProduct;
  final Function(ProductEntities?) onChanged;
  const SelectProduct({
    super.key,
    required this.onChanged,
    this.selectedProduct,
  });

  @override
  ConsumerState<SelectProduct> createState() => _SelectProductState();
}

class _SelectProductState extends ConsumerState<SelectProduct> {
  String? selectedProductId;

  @override
  void initState() {
    super.initState();
    if (widget.selectedProduct != null) {
      selectedProductId = widget.selectedProduct!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productControllerProvider);
    final bool isNotSelected = selectedProductId == null;
    final colorScheme = Theme.of(context).colorScheme;

    final List<ProductEntities> currentProducts = productState.product ?? [];
    final List<String> productIds =
        currentProducts
            .where((p) => p.id != null && (p.quantity ?? 0) > 0)
            .map((p) => p.id!)
            .toList();

    return Skeletonizer(
      effect: LoadingEffect.getCommonEffect(context),
      enabled: productState.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediumTitleWithDegree(
            title: "Produit à commander",
            showDegree: true,
            degree: 1,
          ),

          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceBright.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: CustomDropdown(
              iconData: HugeIcons.strokeRoundedPackage02,
              items: productIds,
              itemLabelBuilder: (id) {
                final p = currentProducts.firstWhere((e) => e.id == id);
                return "${p.name} (${p.quantity} dispo)";
              },
              onChanged: (id) {
                setState(() => selectedProductId = id);
                if (id != null) {
                  final selectedEntity = currentProducts.firstWhere(
                    (p) => p.id == id,
                  );
                  widget.onChanged(selectedEntity);
                }
              },
              textHint: "Sélectionner un produit",
              value: selectedProductId,
            ),
          ),
          SizedBox(height: 5),
          if (isNotSelected)
            Text(
              "Le choix d'un produit est nécessaire",
              style: TextStyle(
                fontSize: 11.sp,
                color: colorScheme.primary.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}
