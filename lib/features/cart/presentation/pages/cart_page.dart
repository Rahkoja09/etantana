import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:e_tantana/features/cart/presentation/controller/cart_session_controller.dart';
import 'package:e_tantana/features/cart/presentation/states/cart_session_state.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:e_tantana/shared/widget/others/empty_content_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartSessionProvider);
    final cartNotifier = ref.read(cartSessionProvider.notifier);
    final carts = cartState.carts ?? [];
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: SimpleAppbar(
        title: "Panier",
        onBack: () => context.pop(),
        // Badge count dans le titre
        trailing:
            carts.isNotEmpty
                ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${carts.length} article${carts.length > 1 ? 's' : ''}",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                )
                : null,
      ),
      body:
          cartState.isEmpty
              ? EmptyContentView(
                icon: Icons.shopping_cart_outlined,
                text: "Votre panier est vide",
              )
              : Column(
                children: [
                  // ── Liste des items ──────────────────────
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(StylesConstants.spacerContent),
                      itemCount: carts.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final item = carts[index];
                        return _CartItemCard(
                          item: item,
                          onRemove:
                              () => cartNotifier.removeItem(
                                item.productId,
                                variantName: item.chosenVariant?['name'],
                              ),
                          onQuantityChanged:
                              (qty) => cartNotifier.updateQuantity(
                                item.productId,
                                qty,
                                variantName: item.chosenVariant?['name'],
                              ),
                        );
                      },
                    ),
                  ),

                  // ── Résumé + bouton commander ────────────
                  _CartSummary(
                    cartState: cartState,
                    onClear: () => cartNotifier.clear(),
                    onOrder: () => context.push('/order/add'),
                  ),
                ],
              ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  CART ITEM CARD
// ─────────────────────────────────────────────────────────────

class _CartItemCard extends StatelessWidget {
  final CartEntity item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;
    final hasVariant = item.chosenVariant != null;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: Row(
        children: [
          // ── Image ──────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 54.r,
              height: 54.r,
              child: ImageViewer(
                borderRadius: 10,
                imageFileOrLink: item.productImage,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // ── Infos ───────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom produit
                Text(
                  item.productName ?? "",
                  style: TextStyles.bodyMedium(
                    context: context,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Variant choisi
                if (hasVariant) ...[
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _buildVariantLabel(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: 6.h),

                // Prix + total
                Row(
                  children: [
                    Text(
                      "${item.unitPrice?.toStringAsFixed(0)} Ar",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "×",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "${item.totalPrice.toStringAsFixed(0)} Ar",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Quantité + supprimer ────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Bouton supprimer
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  HugeIcons.strokeRoundedDelete04,
                  size: 16.sp,
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 8.h),

              // NumberInput
              NumberInput(
                value: item.quantity ?? 1,
                minValue: 1,
                height: 25,
                onValueChanged: onQuantityChanged,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHigh,
                noBorder: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildVariantLabel() {
    final v = item.chosenVariant!;
    final name = v['name']?.toString() ?? '';
    final property = v['property']?.toString();
    if (property != null && property != '-' && property.isNotEmpty) {
      return "$name • $property";
    }
    return name;
  }
}

// ─────────────────────────────────────────────────────────────
//  CART SUMMARY
// ─────────────────────────────────────────────────────────────

class _CartSummary extends StatelessWidget {
  final CartSessionState cartState;
  final VoidCallback onClear;
  final VoidCallback onOrder;

  const _CartSummary({
    required this.cartState,
    required this.onClear,
    required this.onOrder,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: onSurface.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        children: [
          // ── Ligne total ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyles.bodyMedium(
                  context: context,
                  fontWeight: FontWeight.w600,
                  color: onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                "${cartState.totalPrice.toStringAsFixed(0)} Ar",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // ── Boutons ──────────────────────────────────
          Row(
            children: [
              // Vider panier
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete04,
                    color: Theme.of(context).colorScheme.error,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Commander
              Expanded(
                child: FilledButton(
                  onPressed: onOrder,
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Commander",
                    style: TextStyle(
                      fontSize: 14.sp,
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
