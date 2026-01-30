import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class MinimalProductView extends StatefulWidget {
  final ProductEntities product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onOrder;

  const MinimalProductView({
    super.key,
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
    bool newProduct() {
      if (widget.product.createdAt != null) {
        if (("${widget.product.createdAt!.day}/${widget.product.createdAt!.month}/${widget.product.createdAt!.year}") ==
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}") {
          return true;
        } else {
          return false;
        }
      }
      return false;
    }

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
          margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 0.w),
          padding: EdgeInsets.all(StylesConstants.spacerContent - 10),

          decoration: BoxDecoration(
            color:
                outOfStock
                    ? Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  StylesConstants.borderRadius,
                ),
                child: SizedBox(
                  width: 70.w,
                  height: 70.h,
                  child: ImageViewer(
                    imageFileOrLink:
                        widget.product.images ?? AppConst.defaultImage,
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Infos Produit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name ?? "Sans nom",
                      maxLines: 1,
                      style: TextStyles.bodyMedium(
                        context: context,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBadge(
                          context,
                          outOfStock
                              ? "Rupture"
                              : "${widget.product.quantity} en stock",
                          outOfStock ? Colors.red.shade400 : Colors.blueGrey,
                        ),
                        SizedBox(width: 4.h),
                        _buildBadge(
                          context,
                          newProduct() ? "Nouveau" : "En stock",
                          newProduct() ? Colors.green : Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${widget.product.sellingPrice ?? 0} Ar",
                    style: TextStyles.bodyMedium(
                      context: context,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 16.sp,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeight.bold,
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
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: Icon(icon, color: Colors.white, size: 28.sp),
    );
  }
}
