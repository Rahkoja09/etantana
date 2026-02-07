import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/utils/tools/name_more_short.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
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

  const MinimalProductView({
    super.key,
    required this.index,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onOrder,
  });

  @override
  State<MinimalProductView> createState() => _MinimalProductViewState();
}

class _MinimalProductViewState extends State<MinimalProductView> {
  @override
  Widget build(BuildContext context) {
    bool outOfStock = (widget.product.quantity ?? 0) <= 0;

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
        onTap: widget.onEdit,
        child: Container(
          height: 70.h,
          margin: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),

          decoration: BoxDecoration(
            color:
                outOfStock
                    ? Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          ),
          child: Row(
            children: [
              SizedBox(width: 5.w),
              Text(
                "${widget.index}",
                maxLines: 1,
                style: TextStyles.bodyText(
                  context: context,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 18.w),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  StylesConstants.borderRadius,
                ),
                child: SizedBox(
                  width: 58.w,
                  height: 58.h,
                  child: ImageViewer(
                    imageFileOrLink:
                        widget.product.images ?? AppConst.defaultImage,
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Infos Produit ------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      NameMoreShort().shortenName(
                            widget.product.name!.toUpperCase(),
                            30,
                          ) ??
                          "Sans nom",
                      maxLines: 1,
                      style: TextStyles.bodyMedium(
                        context: context,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.product.sellingPrice ?? 0} Ar",
                      style: TextStyles.bodyText(
                        context: context,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Stock",
                    style: TextStyles.bodyMedium(
                      context: context,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    outOfStock ? "Rupture" : "${widget.product.quantity}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: outOfStock ? Colors.red.shade400 : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 5.w),
            ],
          ),
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
