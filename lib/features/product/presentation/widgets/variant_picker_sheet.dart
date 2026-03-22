import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VariantPickerSheet extends StatefulWidget {
  final ProductEntities product;
  final Function(List<CartEntity>) onAdd;

  const VariantPickerSheet({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  State<VariantPickerSheet> createState() => _VariantPickerSheetState();
}

class _VariantPickerSheetState extends State<VariantPickerSheet> {
  // Map index variant → quantité choisie
  final Map<int, int> _quantities = {};

  bool get _hasVariants =>
      widget.product.variant != null && widget.product.variant!.isNotEmpty;

  // Quantité totale sélectionnée
  int get _totalQty => _quantities.values.fold(0, (sum, qty) => sum + qty);

  // Total prix
  double get _totalPrice {
    if (!_hasVariants) return (widget.product.sellingPrice ?? 0) * _totalQty;

    double total = 0;
    _quantities.forEach((index, qty) {
      if (qty > 0) {
        final variant = widget.product.variant![index];
        final price =
            variant['price'] != null
                ? (variant['price'] as num).toDouble()
                : widget.product.sellingPrice ?? 0;
        total += price * qty;
      }
    });
    return total;
  }

  void _submit() {
    // Aucune sélection
    if (_totalQty == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Choisissez au moins un variant"),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final List<CartEntity> items = [];

    if (_hasVariants) {
      _quantities.forEach((index, qty) {
        if (qty > 0) {
          final variant = widget.product.variant![index];
          final price =
              variant['price'] != null
                  ? (variant['price'] as num).toDouble()
                  : widget.product.sellingPrice ?? 0;
          items.add(
            CartEntity(
              productId: widget.product.id,
              productName: widget.product.name,
              productImage:
                  variant['image']?.toString().isNotEmpty == true
                      ? variant['image']
                      : widget.product.images,
              unitPrice: price,
              purchasePrice: widget.product.purchasePrice,
              quantity: qty,
              chosenVariant: variant,
              shopId: widget.product.shopId,
            ),
          );
        }
      });
    } else {
      // Pas de variants — produit simple
      items.add(
        CartEntity(
          productId: widget.product.id,
          productName: widget.product.name,
          productImage: widget.product.images,
          unitPrice: widget.product.sellingPrice,
          purchasePrice: widget.product.purchasePrice,
          quantity: _quantities[0] ?? 1,
          shopId: widget.product.shopId,
        ),
      );
    }

    widget.onAdd(items);
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
          // ── Handle ────────────────────────────────────
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

          // ── Header produit ─────────────────────────────
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
                      "${widget.product.sellingPrice?.toStringAsFixed(0)} Ar",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ── Variants ──────────────────────────────────
          if (_hasVariants) ...[
            Text(
              "Choisir les variants",
              style: TextStyles.bodyMedium(
                context: context,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),

            // Liste verticale scrollable si beaucoup de variants
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 260.h),
              child: SingleChildScrollView(
                child: Column(
                  children:
                      widget.product.variant!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final variant = entry.value;
                        final qty = _quantities[index] ?? 0;
                        final variantQty = variant['quantity'] as int? ?? 0;
                        final outOfStock = variantQty <= 0;
                        final isSelected = qty > 0;
                        final price =
                            variant['price'] != null
                                ? (variant['price'] as num).toDouble()
                                : null;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  outOfStock
                                      ? onSurface.withValues(alpha: 0.03)
                                      : isSelected
                                      ? primary.withValues(alpha: 0.06)
                                      : Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(
                                StylesConstants.borderRadius,
                              ),
                              border: Border.all(
                                color:
                                    outOfStock
                                        ? onSurface.withValues(alpha: 0.06)
                                        : isSelected
                                        ? primary.withValues(alpha: 0.3)
                                        : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Image miniature
                                if (variant['image'] != null &&
                                    variant['image'].toString().isNotEmpty) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: SizedBox(
                                      width: 36.r,
                                      height: 36.r,
                                      child: ImageViewer(
                                        borderRadius: 6,
                                        imageFileOrLink: variant['image'],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                ],

                                // Infos variant
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            variant['name']?.toString() ?? "-",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  outOfStock
                                                      ? onSurface.withValues(
                                                        alpha: 0.3,
                                                      )
                                                      : onSurface,
                                            ),
                                          ),
                                          if (variant['variant_type'] != null &&
                                              variant['variant_type'] !=
                                                  '-') ...[
                                            SizedBox(width: 6.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5.w,
                                                vertical: 1.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: primary.withValues(
                                                  alpha: 0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                variant['variant_type']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 9.sp,
                                                  color: primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Row(
                                        children: [
                                          // Property
                                          if (variant['property'] != null &&
                                              variant['property'] != '-')
                                            Text(
                                              variant['property'].toString(),
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: onSurface.withValues(
                                                  alpha:
                                                      outOfStock ? 0.2 : 0.45,
                                                ),
                                              ),
                                            ),
                                          if (variant['property'] != null &&
                                              variant['property'] != '-')
                                            SizedBox(width: 8.w),

                                          // Prix spécifique
                                          if (price != null)
                                            Text(
                                              "${price.toStringAsFixed(0)} Ar",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    outOfStock
                                                        ? onSurface.withValues(
                                                          alpha: 0.2,
                                                        )
                                                        : primary,
                                              ),
                                            ),

                                          // Stock
                                          if (!outOfStock) ...[
                                            SizedBox(width: 8.w),
                                            Text(
                                              "stock: $variantQty",
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                                color: onSurface.withValues(
                                                  alpha: 0.3,
                                                ),
                                              ),
                                            ),
                                          ],

                                          if (outOfStock)
                                            Text(
                                              "Rupture",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.error,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Mini NumberInput à droite
                                if (!outOfStock)
                                  _MiniNumberInput(
                                    value: qty,
                                    max: variantQty,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == 0) {
                                          _quantities.remove(index);
                                        } else {
                                          _quantities[index] = val;
                                        }
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ] else ...[
            // ── Produit sans variant — quantité simple ──
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
                _MiniNumberInput(
                  value: _quantities[0] ?? 1,
                  max: widget.product.quantity ?? 999,
                  onChanged:
                      (val) =>
                          setState(() => _quantities[0] = val == 0 ? 1 : val),
                ),
              ],
            ),
          ],

          SizedBox(height: 20.h),

          // ── Total + bouton ajouter ─────────────────────
          Row(
            children: [
              // Total
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  Text(
                    "${_totalPrice.toStringAsFixed(0)} Ar",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),

              // Bouton
              Expanded(
                child: FilledButton(
                  onPressed: _totalQty > 0 ? _submit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    disabledBackgroundColor: onSurface.withValues(alpha: 0.1),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _totalQty > 0
                        ? "Ajouter $_totalQty article${_totalQty > 1 ? 's' : ''}"
                        : "Ajouter au panier",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color:
                          _totalQty > 0
                              ? Colors.white
                              : onSurface.withValues(alpha: 0.3),
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

// ─────────────────────────────────────────────────────────────
//  MINI NUMBER INPUT — compact, fait pour les listes
// ─────────────────────────────────────────────────────────────

class _MiniNumberInput extends StatelessWidget {
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  const _MiniNumberInput({
    required this.value,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final canDecrement = value > 0;
    final canIncrement = value < max;

    return Container(
      height: 30.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Moins
          GestureDetector(
            onTap: canDecrement ? () => onChanged(value - 1) : null,
            child: Container(
              width: 28.w,
              height: double.infinity,
              decoration: BoxDecoration(
                color:
                    canDecrement
                        ? primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
              ),
              child: Icon(
                Icons.remove_rounded,
                size: 13.sp,
                color:
                    canDecrement ? primary : onSurface.withValues(alpha: 0.2),
              ),
            ),
          ),

          // Valeur
          SizedBox(
            width: 28.w,
            child: Center(
              child: Text(
                "$value",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: value > 0 ? primary : onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),

          // Plus
          GestureDetector(
            onTap: canIncrement ? () => onChanged(value + 1) : null,
            child: Container(
              width: 28.w,
              height: double.infinity,
              decoration: BoxDecoration(
                color:
                    canIncrement
                        ? primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 13.sp,
                color:
                    canIncrement ? primary : onSurface.withValues(alpha: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
