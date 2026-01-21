import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstHeader extends StatelessWidget {
  final OrderEntities order;
  final ProductEntities product;
  const FirstHeader({super.key, required this.order, required this.product});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: color),
          child: Text(
            "Facturation",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white,
              fontFamily: "BrunoAceSC",
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "${product.name}",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: "Nonito",
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          "${order.createdAt?.day}/${order.createdAt?.month}/${order.createdAt?.year}",
          style: TextStyle(
            color: color,
            fontSize: 16.sp,
            fontFamily: "Nonito",
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}
