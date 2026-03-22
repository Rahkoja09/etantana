import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/utils/tools/name_more_short.dart';
import 'package:e_tantana/features/cart/presentation/controller/cart_session_controller.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/widgets/variant_picker_sheet.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

// ── Mode du widget ────────────────────────────────────────────
enum ProductViewMode {
  manage, // swipe delete/edit + checkbox pack
  cart, // bouton + pour ajouter au panier
}

class MinimalProductView extends ConsumerStatefulWidget {
  final int index;
  final ProductEntities product;
  final ProductViewMode mode;

  // Mode manage uniquement
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onLongPress;
  final ValueChanged<int>? selectedQuantity;

  const MinimalProductView({
    super.key,
    required this.index,
    required this.product,
    this.mode = ProductViewMode.manage,
    this.onDelete,
    this.onEdit,
    this.onLongPress,
    this.selectedQuantity,
  });

  @override
  ConsumerState<MinimalProductView> createState() => _MinimalProductViewState();
}

class _MinimalProductViewState extends ConsumerState<MinimalProductView> {
  int quantity = 0;

  bool get _isSelected => quantity > 0;
  bool get _outOfStock => (widget.product.quantity ?? 0) <= 0;
  bool get _isPack => widget.product.isPack ?? false;
  bool get _hasVariants =>
      widget.product.variant != null && widget.product.variant!.isNotEmpty;

  // Quantité dans le panier pour ce produit
  int get _cartQuantity {
    final carts = ref.watch(cartSessionProvider).carts ?? [];
    return carts
        .where((e) => e.productId == widget.product.id)
        .fold(0, (sum, e) => sum + (e.quantity ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        color:
            _outOfStock
                ? Theme.of(context).colorScheme.error.withValues(alpha: 0.06)
                : _isPack
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
                : Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border.all(
          width: 1,
          color:
              _cartQuantity > 0
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)
                  : _isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                  : _outOfStock
                  ? Theme.of(context).colorScheme.error.withValues(alpha: 0.2)
                  : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          _buildImage(context),
          SizedBox(width: 12.w),
          Expanded(child: _buildInfo(context)),
        ],
      ),
    );

    // Mode manage — avec swipe
    if (widget.mode == ProductViewMode.manage) {
      return Dismissible(
        key: Key(widget.product.id.toString()),
        dismissThresholds: const {
          DismissDirection.startToEnd: 0.9,
          DismissDirection.endToStart: 0.9,
        },
        dragStartBehavior: DragStartBehavior.down,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            widget.onDelete?.call();
          } else {
            widget.onEdit?.call();
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
        child: GestureDetector(onLongPress: widget.onLongPress, child: child),
      );
    }

    // Mode cart — sans swipe
    return GestureDetector(
      onTap: _outOfStock ? null : () => _openVariantPicker(context),
      child: child,
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

        // Badge panier — mode cart uniquement
        if (widget.mode == ProductViewMode.cart && _cartQuantity > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                "$_cartQuantity",
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
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

            // Mode manage → NumberInput
            if (widget.mode == ProductViewMode.manage)
              SizedBox(
                height: 26.h,
                child: NumberInput(
                  value: 0,
                  onValueChanged: (value) {
                    setState(() {
                      quantity = value;
                      widget.selectedQuantity?.call(value);
                    });
                  },
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHigh,
                  noBorder: true,
                  minValue: 0,
                ),
              ),

            // Mode cart → bouton "+"
            if (widget.mode == ProductViewMode.cart && !_outOfStock)
              GestureDetector(
                onTap: () => _openVariantPicker(context),
                child: Container(
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 6.h),

        Row(
          children: [
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

            // Badge variants — mode cart
            if (widget.mode == ProductViewMode.cart && _hasVariants) ...[
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "${widget.product.variant!.length} variants",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ── Variant Picker ────────────────────────────────────────
  void _openVariantPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (_) => VariantPickerSheet(
            product: widget.product,
            onAdd: (cartItems) {
              for (final item in cartItems) {
                ref.read(cartSessionProvider.notifier).addItem(item);
              }
              Navigator.pop(context);
            },
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
      child: Icon(icon, color: Colors.white, size: 22.sp),
    );
  }
}
