import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultipleProductViewOrder extends StatefulWidget {
  final List<ProductEntities?> productsToOrder;
  const MultipleProductViewOrder({super.key, required this.productsToOrder});

  @override
  State<MultipleProductViewOrder> createState() =>
      _MultipleProductViewOrderState();
}

class _MultipleProductViewOrderState extends State<MultipleProductViewOrder> {
  @override
  Widget build(BuildContext context) {
    if (widget.productsToOrder.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: ListView.builder(
        itemCount: widget.productsToOrder.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final product = widget.productsToOrder[index];
          final imageUrl =
              product?.images ?? "https://ton-image-par-defaut.com";

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                imageUrl,
                height: 40.h,
                width: 40.w,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 30.sp),
              ),
            ),
          );
        },
      ),
    );
  }
}
