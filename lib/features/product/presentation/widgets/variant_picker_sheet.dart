import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VariantPickerSheet extends StatefulWidget {
  final ProductEntities product;
  final Function(CartEntity) onAdd;

  const VariantPickerSheet({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  State<VariantPickerSheet> createState() => _VariantPickerSheetState();
}

class _VariantPickerSheetState extends State<VariantPickerSheet> {
  Map<String, dynamic>? _selectedVariant;
  int _quantity = 1;

  bool get _hasVariants =>
      widget.product.variant != null && widget.product.variant!.isNotEmpty;

  double get _effectivePrice {
    if (_selectedVariant?['price'] != null) {
      return (_selectedVariant!['price'] as num).toDouble();
    }
    return widget.product.sellingPrice ?? 0;
  }

  double get _effectivePurchasePrice {
    return widget.product.purchasePrice ?? 0;
  }

  @override
  void initState() {
    super.initState();
    // Si pas de variants — sélection automatique
    if (!_hasVariants) _selectedVariant = null;
  }

  void _submit() {
    // Si le produit a des variants — forcer la sélection
    if (_hasVariants && _selectedVariant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veuillez choisir un variant"),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    widget.onAdd(
      CartEntity(
        productId: widget.product.id,
        productName: widget.product.name,
        productImage:
            _selectedVariant?['image']?.toString().isNotEmpty == true
                ? _selectedVariant!['image']
                : widget.product.images,
        unitPrice: _effectivePrice,
        purchasePrice: _effectivePurchasePrice,
        quantity: _quantity,
        chosenVariant: _selectedVariant,
        shopId: widget.product.shopId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surface = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ──────────────────────────────────────
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: onSurface.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // ── Header produit ───────────────────────────────
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 48.r,
                  height: 48.r,
                  child: ImageViewer(
                    borderRadius: 10,
                    imageFileOrLink:
                        widget.product.images ?? AppConst.defaultImage,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name ?? "",
                      style: TextStyles.titleSmall(
                        context: context,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${_effectivePrice.toStringAsFixed(0)} Ar",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // ── Sélection variant ────────────────────────────
          if (_hasVariants) ...[
            Text(
              "Choisir un variant *",
              style: TextStyles.bodyMedium(
                context: context,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children:
                  widget.product.variant!.map((variant) {
                    final isSelected = _selectedVariant == variant;
                    final variantQty = variant['quantity'] as int? ?? 0;
                    final outOfStock = variantQty <= 0;

                    return GestureDetector(
                      onTap:
                          outOfStock
                              ? null
                              : () =>
                                  setState(() => _selectedVariant = variant),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              outOfStock
                                  ? onSurface.withValues(alpha: 0.04)
                                  : isSelected
                                  ? primary
                                  : primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                outOfStock
                                    ? onSurface.withValues(alpha: 0.1)
                                    : isSelected
                                    ? primary
                                    : primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image miniature si disponible
                            if (variant['image'] != null &&
                                variant['image'].toString().isNotEmpty) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 40.r,
                                  height: 40.r,
                                  child: ImageViewer(
                                    borderRadius: 6,
                                    imageFileOrLink: variant['image'],
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                            ],
                            Text(
                              variant['name']?.toString() ?? "-",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color:
                                    outOfStock
                                        ? onSurface.withValues(alpha: 0.3)
                                        : isSelected
                                        ? Colors.white
                                        : primary,
                              ),
                            ),
                            if (variant['property'] != null &&
                                variant['property'] != '-')
                              Text(
                                variant['property'].toString(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color:
                                      outOfStock
                                          ? onSurface.withValues(alpha: 0.2)
                                          : isSelected
                                          ? Colors.white.withValues(alpha: 0.8)
                                          : onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            Text(
                              outOfStock ? "Rupture" : "Qté: $variantQty",
                              style: TextStyle(
                                fontSize: 9.sp,
                                color:
                                    outOfStock
                                        ? Theme.of(context).colorScheme.error
                                        : isSelected
                                        ? Colors.white.withValues(alpha: 0.7)
                                        : onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 20.h),
          ],

          // ── Quantité ─────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quantité",
                style: TextStyles.bodyMedium(
                  context: context,
                  fontWeight: FontWeight.w700,
                ),
              ),
              NumberInput(
                value: _quantity,
                minValue: 1,
                onValueChanged: (val) => setState(() => _quantity = val),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // ── Total + bouton ajouter ────────────────────────
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  Text(
                    "${(_effectivePrice * _quantity).toStringAsFixed(0)} Ar",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Ajouter au panier",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
