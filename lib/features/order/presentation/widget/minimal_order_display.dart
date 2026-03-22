import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/enums/order_status.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/shared/widget/actions/swipe_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class MinimalOrderDisplay extends StatelessWidget {
  final OrderEntities order;
  final ValueChanged<String> swipeAction;
  final VoidCallback onTap;

  const MinimalOrderDisplay({
    super.key,
    required this.order,
    required this.swipeAction,
    required this.onTap,
  });

  double get _total {
    double total = 0.0;
    for (final item in order.productsAndQuantities ?? []) {
      final price = (item["unit_price"] as num?)?.toDouble() ?? 0;
      final qty = (item["quantity"] as num?)?.toInt() ?? 0;
      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(StylesConstants.borderRadius);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;

    return SwipeAction(
      dismissibleKey: Key(order.id ?? ""),
      actionBorderRadius: borderRadius,
      leftAction: DismissibleAction(
        backgroundColor: Colors.red.shade400,
        icon: HugeIcons.strokeRoundedDelete02,
        onDismiss: () => swipeAction("leftSwipeOrder"),
      ),
      rightAction: DismissibleAction(
        backgroundColor: Colors.green.shade400,
        icon: HugeIcons.strokeRoundedEdit04,
        onDismiss: () => swipeAction("rightSwipeOrder"),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header : status + date ─────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Badge status
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: order.status?.materialColor ?? primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status?.label ?? "",
                      style: TextStyles.bodySmall(
                        context: context,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // Date
                  if (order.deliveryDate != null)
                    Text(
                      _formatDate(order.deliveryDate!),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10.h),

              // ── Client ────────────────────────────────
              Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    color: onSurface.withValues(alpha: 0.4),
                    size: 13,
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      "${order.clientName?.toUpperCase() ?? '-'}  •  ${order.clientTel ?? ''}",
                      style: TextStyles.bodyMedium(
                        context: context,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // Adresse
              Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedMapsLocation01,
                    color: onSurface.withValues(alpha: 0.35),
                    size: 12,
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      order.clientAdrs ?? "-",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: onSurface.withValues(alpha: 0.45),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // ── Produits commandés ────────────────────
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children:
                      (order.productsAndQuantities ?? [])
                          .map((item) => _ProductLine(item: item))
                          .toList(),
                ),
              ),
              SizedBox(height: 10.h),

              // ── Footer : total + bouton facturer ──────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Frais de livraison
                  Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedDeliveryTruck02,
                        color: onSurface.withValues(alpha: 0.35),
                        size: 13,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "${order.deliveryCosts?.toStringAsFixed(0) ?? 0} Ar",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),

                  // Total
                  Row(
                    children: [
                      Text(
                        "Total : ",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        "${_total.toStringAsFixed(0)} Ar",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: onSurface,
                        ),
                      ),
                    ],
                  ),

                  // Bouton facturer
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedInvoice03,
                            color: primary,
                            size: 12,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Facturer",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}

class _ProductLine extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ProductLine({required this.item});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;

    // ✅ Fix — chaque item a sa propre quantité
    final name = item["product_name"]?.toString() ?? "-";
    final qty = (item["quantity"] as num?)?.toInt() ?? 0;
    final price = (item["unit_price"] as num?)?.toDouble() ?? 0;
    final variant = item["chosen_variant"] as Map<String, dynamic>?;
    final variantName = variant?['name']?.toString();
    final variantProperty = variant?['property']?.toString();

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          // Bullet
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(width: 8.w),

          // Nom + variant
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (variantName != null)
                  Text(
                    _buildVariantLabel(variantName, variantProperty),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: primary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Quantité × prix
          Text(
            "×$qty  ${(price * qty).toStringAsFixed(0)} Ar",
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _buildVariantLabel(String name, String? property) {
    if (property != null && property != '-' && property.isNotEmpty) {
      return "$name • $property";
    }
    return name;
  }
}
