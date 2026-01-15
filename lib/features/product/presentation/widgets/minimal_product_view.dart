import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class MinimalProductView extends StatelessWidget {
  final ProductEntities product;
  final VoidCallback onEdit;
  final VoidCallback order;

  const MinimalProductView({
    super.key,
    required this.product,
    required this.onEdit,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    String defaultText = "Produit sans nom";
    bool outOfStock = (product.quantity ?? 0) <= 0;

    return Container(
      height: 65.h,
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color:
            outOfStock
                ? Theme.of(
                  context,
                ).colorScheme.errorContainer.withValues(alpha: 0.09)
                : Theme.of(
                  context,
                ).colorScheme.surfaceContainerLow.withValues(alpha: 0.3),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        child: Row(
          children: [
            SizedBox(
              width: 60.w,
              height: double.infinity,
              child: ImageViewer(
                imageFileOrLink: product.images ?? AppConst.defaultImage,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name ?? defaultText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.bodyMedium(
                        context: context,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          "Stock: ",
                          style: TextStyles.bodySmall(context: context),
                        ),
                        Text(
                          product.quantity.toString(),
                          style: TextStyles.bodySmall(
                            context: context,
                            fontWeight: FontWeight.bold,
                            color:
                                outOfStock
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20.sp,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.6),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  Container(
                    height: 20.h,
                    width: 1,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                  ),
                  IconButton(
                    onPressed: order,
                    icon: Icon(
                      HugeIcons.strokeRoundedShoppingBasketCheckIn01,
                      size: 20.sp,
                      color:
                          product.quantity! <= 0
                              ? Theme.of(context).colorScheme.error
                              : Colors.green,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
