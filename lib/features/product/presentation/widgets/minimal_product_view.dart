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
  final ValueChanged<int> selectedQuantity;
  final bool? isSelected;

  const MinimalProductView({
    super.key,
    required this.index,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onOrder,
    required this.selectedQuantity,
    this.isSelected = false,
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
          height: 80.h,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
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
                    : Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: [
              if (widget.isSelected!) ...[
                Checkbox(value: true, onChanged: (value) {}),
                SizedBox(width: 18.w),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
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
                          outOfStock
                              ? "Rupture de Stock"
                              : "Stock . ${widget.product.quantity}",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color:
                                outOfStock
                                    ? Colors.red.shade400
                                    : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Ar ${widget.product.sellingPrice ?? 0}",
                              style: TextStyles.bodySmall(
                                context: context,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
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
