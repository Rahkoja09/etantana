import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class FirstLabel extends StatelessWidget {
  final OrderEntities order;
  final double totalProducts;
  final double delivery;
  const FirstLabel({
    super.key,
    required this.order,
    required this.totalProducts,
    required this.delivery,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: color),
          child: Center(
            child: Text(
              order.clientTel ?? 'N/A',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: Colors.white,
                fontFamily: "BrunoAceSC",
              ),
            ),
          ),
        ),

        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(width: 3, color: color)),
          child: Center(
            child: Text(
              order.clientName?.toUpperCase() ?? "CLIENT INCONNU",
              textAlign: TextAlign.center,
              style: TextStyles.titleLarge(context: context, color: color),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(width: 3, color: color)),
          child: Center(
            child: Text(
              order.clientAdrs ?? "À récupérer en magasin",
              textAlign: TextAlign.center,
              style: TextStyles.titleLarge(context: context, color: color),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(3),
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(width: 3, color: color)),
          child: Text(
            "Prix: ${totalProducts.toInt() * order.quantity!.toInt()} Ar + ${delivery.toInt()} Ar frais de liv.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Nonito",
              fontSize: 22.sp,
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
