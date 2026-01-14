import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinimalOrderDisplay extends ConsumerWidget {
  final OrderEntities order;
  const MinimalOrderDisplay({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productControllerProvider);

    String getProductName(String productId) {
      String productName = "";
      for (ProductEntities product in productState.product) {
        if (product.id == productId) {
          productName = product.name!;
        }
      }
      return productName;
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
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

          Text(
            getProductName(order.productId.toString()),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Liv: ${order.clientAdrs}(${order.deliveryCosts.toString()} Ar)",
                    style: TextStyles.bodyText(
                      context: context,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
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
                    "${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}",
                    style: TextStyles.bodySmall(
                      context: context,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
