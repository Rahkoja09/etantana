import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/shared/widget/input/custom_drop_down.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/custom_dialog.dart';
import 'package:e_tantana/shared/widget/text/medium_title_with_degree.dart';
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

    final List<String> productIds = [];
    final List<ProductEntities> currentProducts =
        productState.product != null
            ? List<ProductEntities>.from(productState.product!)
            : [];

    for (var p in currentProducts) {
      if (p.id != null) {
        productIds.add(p.id!);
      }
    }

    ref.listen<ProductState>(productControllerProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        showDialog(
          context: context,
          builder:
              (context) => ErrorDialog(
                title: "Erreur de récupération produit.",
                message: next.errorMessage!,
              ),
        );
      }
    });

    return Skeletonizer(
      effect: LoadingEffect.getCommonEffect(context),
      enabled: productState.isLoading,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color:
              isNotSelected
                  ? Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.05)
                  : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          border: Border.all(
            color:
                isNotSelected
                    ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3)
                    : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
            width: isNotSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  HEADER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    MediumTitleWithDegree(
                      title: "PRODUIT(S) COMMANDÉ",
                      showDegree: false,
                    ),
                    SizedBox(width: 8.w),
                    if (isNotSelected)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "REQUIS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Icon(
                  isNotSelected
                      ? Icons.error_outline
                      : Icons.check_circle_outline,
                  size: 18.sp,
                  color:
                      isNotSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.green,
                ),
              ],
            ),

            SizedBox(height: 10.h),

            //  DROPDOWN ---
            CustomDropdown(
              iconData: HugeIcons.strokeRoundedPackage,
              items: productIds,
              itemLabelBuilder: (id) {
                try {
                  final p = currentProducts.firstWhere((e) => e.id == id);
                  return "${p.name} . Qté dispo : ${p.quantity}";
                } catch (e) {
                  return "Produit introuvable";
                }
              },
              onChanged: (id) {
                setState(() {
                  selectedProductId = id;
                });
                if (id != null) {
                  try {
                    final selectedEntity = currentProducts.firstWhere(
                      (p) => p.id == id,
                    );
                    widget.onChanged(selectedEntity);
                  } catch (_) {
                    widget.onChanged(null);
                  }
                }
              },
              textHint: "CLIQUEZ POUR CHOISIR UN PRODUIT",
              value: selectedProductId,
            ),

            // --- MESSAGE D'ERREUR ---
            if (isNotSelected)
              Padding(
                padding: EdgeInsets.only(top: 8.h, left: 4.w),
                child: Text(
                  "Veuillez sélectionner le produit",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
