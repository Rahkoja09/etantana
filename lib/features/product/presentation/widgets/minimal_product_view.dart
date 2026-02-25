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
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onLongPress;
  final ValueChanged<int> selectedQuantity;

  const MinimalProductView({
    super.key,
    required this.index,
    required this.product,
    required this.onDelete,
    required this.onEdit,
    required this.selectedQuantity,
    required this.onLongPress,
  });

  @override
  State<MinimalProductView> createState() => _MinimalProductViewState();
}

class _MinimalProductViewState extends State<MinimalProductView> {
  int quantity = 0;
  bool IsSelected(int value) {
    return value > 0;
  }

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
          widget.onEdit();
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
        icon: HugeIcons.strokeRoundedTaskEdit01,
        alignment: Alignment.centerRight,
      ),
      child: GestureDetector(
        onLongPress: widget.onLongPress,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            if (isPackProduct)
              Positioned(
                bottom: -40,
                right: -10,
                child: Transform.rotate(
                  angle: -0.60,
                  child: Icon(
                    Icons.inventory_2,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.1),
                    size: 100.sp,
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  StylesConstants.borderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        IsSelected(quantity)
                            ? Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.1)
                            : Colors.transparent,
                    blurRadius: 2,
                    offset: Offset(3, 3),
                    spreadRadius: 0.2,
                  ),
                ],
                border: Border.all(
                  width: 0.2,
                  color:
                      IsSelected(quantity) ? Colors.blue : Colors.transparent,
                ),
                color:
                    outOfStock
                        ? Theme.of(
                          context,
                        ).colorScheme.error.withValues(alpha: 0.15)
                        : isPackProduct
                        ? Colors.blue.withValues(alpha: 0.06)
                        : Theme.of(context).colorScheme.surfaceContainerLow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: ImageViewer(
                              borderRadius: 8,
                              imageFileOrLink:
                                  isPackProduct
                                      ? "assets/medias/logos/pack_default_image.jpg"
                                      : widget.product.images ??
                                          AppConst.defaultImage,
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
                                  borderRadius: BorderRadius.circular(8),
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
                                  style: TextStyles.bodyMedium(
                                    context: context,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.product.sellingPrice} Ar",
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
                                    SizedBox(
                                      height: 25.h,
                                      child: NumberInput(
                                        value: 0,
                                        onValueChanged: (value) {
                                          setState(() {
                                            widget.selectedQuantity(value);
                                            quantity = value;
                                          });
                                        },
                                        backgroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surfaceContainerHigh,
                                        noBorder: true,
                                        minValue: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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
