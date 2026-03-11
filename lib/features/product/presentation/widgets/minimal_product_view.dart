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

  bool get _isSelected => quantity > 0;
  bool get _outOfStock => (widget.product.quantity ?? 0) <= 0;
  bool get _isPack => widget.product.isPack ?? false;

  @override
  Widget build(BuildContext context) {
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
        } else {
          widget.onEdit();
        }
        return false;
      },
      background: _buildSwipeAction(
        color: Theme.of(context).colorScheme.error,
        icon: HugeIcons.strokeRoundedDelete02,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeAction(
        color: Colors.green.shade500,
        icon: HugeIcons.strokeRoundedTaskEdit01,
        alignment: Alignment.centerRight,
      ),
      child: GestureDetector(
        onLongPress: widget.onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            color:
                _outOfStock
                    ? Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.06)
                    : _isPack
                    ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.05)
                    : Theme.of(context).colorScheme.surfaceContainerLow,
            border: Border.all(
              width: 1,
              color:
                  _isSelected
                      ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3)
                      : _outOfStock
                      ? Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: 0.2)
                      : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Image
              _buildImage(context),
              SizedBox(width: 12.w),

              // Infos
              Expanded(child: _buildInfo(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 54.w,
            height: 54.h,
            child: ImageViewer(
              borderRadius: 8,
              imageFileOrLink:
                  _isPack
                      ? "assets/medias/logos/pack_default_image.jpg"
                      : widget.product.images ?? AppConst.defaultImage,
            ),
          ),
        ),

        // Badge pack
        if (_isPack)
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "+${widget.product.packComposition?.length ?? 0}",
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),

        // Badge rupture
        if (_outOfStock)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.block_rounded,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nom + quantity input
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                NameMoreShort().shortenName(widget.product.name!, 28),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.bodyMedium(
                  context: context,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            SizedBox(
              height: 26.h,
              child: NumberInput(
                value: 0,
                onValueChanged: (value) {
                  setState(() {
                    quantity = value;
                    widget.selectedQuantity(value);
                  });
                },
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHigh,
                noBorder: true,
                minValue: 0,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),

        // Prix + stock
        Row(
          children: [
            // Prix
            Text(
              "${widget.product.sellingPrice} Ar",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color:
                    _outOfStock
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 10.w),

            // Séparateur
            Container(
              width: 3.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.w),

            // Stock
            Row(
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _outOfStock ? Colors.red.shade400 : Colors.green,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  _outOfStock ? "Rupture" : "${widget.product.quantity}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        _outOfStock
                            ? Colors.red.shade400
                            : Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
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
      child: Icon(icon, color: Colors.white, size: 22.sp),
    );
  }
}
