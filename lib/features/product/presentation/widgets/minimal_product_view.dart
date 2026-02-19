import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/utils/tools/name_more_short.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class MinimalProductView extends StatefulWidget {
  final int index;
  final ProductEntities product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onOrder;
  final VoidCallback onLongPress;
  final ValueChanged<int> selectedQuantity;

  const MinimalProductView({
    super.key,
    required this.index,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onOrder,
    required this.selectedQuantity,
    required this.onLongPress,
  });

  @override
  State<MinimalProductView> createState() => _MinimalProductViewState();
}

class _MinimalProductViewState extends State<MinimalProductView> {
  @override
  Widget build(BuildContext context) {
    final bool outOfStock = (widget.product.quantity ?? 0) <= 0;
    final bool isPackProduct = widget.product.isPack ?? false;

    return Dismissible(
      key: Key(widget.product.id.toString()),
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.9,
        DismissDirection.endToStart: 0.9,
      },
      dragStartBehavior: DragStartBehavior.down,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onDelete();
          return false;
        } else {
          widget.onOrder();
          return false;
        }
      },
      background: _buildSwipeAction(
        color: Colors.red.shade400,
        icon: HugeIcons.strokeRoundedDelete02,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeAction(
        color: Colors.green.shade400,
        icon: HugeIcons.strokeRoundedShoppingBasketCheckIn01,
        alignment: Alignment.centerRight,
      ),
      child: GestureDetector(
        onLongPress: widget.onLongPress,
        onTap: widget.onEdit,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  StylesConstants.borderRadius,
                ),
                border: Border.all(
                  width: 0.2,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                color:
                    outOfStock
                        ? Theme.of(
                          context,
                        ).colorScheme.error.withValues(alpha: 0.15)
                        : isPackProduct
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Theme.of(context).colorScheme.surfaceContainerLowest
                            .withValues(alpha: 0.4),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: SizedBox(
                              width: 58.w,
                              height: 58.h,
                              child: ImageViewer(
                                imageFileOrLink:
                                    isPackProduct
                                        ? "assets/medias/logos/pack_default_image.jpg"
                                        : widget.product.images ??
                                            AppConst.defaultImage,
                              ),
                            ),
                          ),
                          if (isPackProduct)
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(
                                    StylesConstants.borderRadius,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "+${widget.product.packComposition?.length ?? 0}",
                                    style: TextStyles.bodyText(
                                      context: context,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 16.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  NameMoreShort().shortenName(
                                        widget.product.name!,
                                        30,
                                      ) ??
                                      "Sans nom",
                                  maxLines: 1,
                                  style: TextStyles.bodyText(
                                    context: context,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Ref:${widget.product.eId?.toUpperCase()}",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color:
                                        outOfStock
                                            ? Colors.red.shade400
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 3.h),
                                Text(
                                  outOfStock
                                      ? "Rupture de Stock"
                                      : "Stock . ${widget.product.quantity}",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color:
                                        outOfStock
                                            ? Colors.red.shade400
                                            : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ar ${widget.product.sellingPrice ?? 0}",
                        style: TextStyles.bodyMedium(
                          context: context,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                        child: NumberInput(
                          value: 0,
                          onValueChanged: (value) {
                            setState(() => widget.selectedQuantity(value));
                          },
                          noBorder: true,
                          minValue: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isPackProduct)
              Positioned(
                top: 0,
                right: 0,
                child: Transform.rotate(
                  angle: 0.00,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(StylesConstants.borderRadius),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedPackage02,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "PACK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeAction({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(color: color),
      child: Icon(icon, color: Colors.white, size: 28.sp),
    );
  }
}
