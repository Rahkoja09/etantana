import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/utils/tools/name_more_short.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';

class MinimalOrderDisplay extends ConsumerWidget {
  final OrderEntities order;
  final VoidCallback onTap;
  const MinimalOrderDisplay({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productControllerProvider);

    String getProductName(String productId) {
      if (productState.product == null) return "Chargement...";

      try {
        final product = (productState.product as List<ProductEntities>)
            .firstWhere((p) => p.id == productId);
        return product.name ?? "Sans nom";
      } catch (e) {
        return "Produit inconnu";
      }
    }

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.9),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            ),
            child: Text(
              order.status.toString(),
              style: TextStyles.bodySmall(
                context: context,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "${order.clientName.toString().toUpperCase()} (${order.clientTel.toString()})",
            style: TextStyles.bodyMedium(
              context: context,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (order.productsAndQuantities?.length == 1) ...[
            Text(
              getProductName(order.productsAndQuantities![0]["id"].toString()),
              style: TextStyles.bodyMedium(
                context: context,
                fontWeight: FontWeight.w600,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            Text(
              "Qté(s). commandé : ${order.quantity.toString()}",
              style: TextStyles.bodyMedium(
                context: context,
                fontWeight: FontWeight.w600,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
          if (order.productsAndQuantities != null &&
              order.productsAndQuantities!.length > 1) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: order.productsAndQuantities?.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text(
                      "-> ${getProductName(order.productsAndQuantities![index]["id"].toString())} . Qté: ${order.productsAndQuantities![index]["quantity"]}",
                      style: TextStyles.bodyMedium(
                        context: context,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
          Text(
            "Liv: ${order.clientAdrs} (${order.deliveryCosts.toString()} Ar)",
            style: TextStyles.bodyText(
              context: context,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.9),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "ID:",
                      style: TextStyles.bodyMedium(
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      NameMoreShort().shortenName("${order.id}", 5),
                      style: TextStyles.bodyMedium(
                        context: context,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                        StylesConstants.borderRadius,
                      ),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.7,
                      ),
                    ),
                    child: Text(
                      "Facturer",
                      style: TextStyles.bodySmall(
                        context: context,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
