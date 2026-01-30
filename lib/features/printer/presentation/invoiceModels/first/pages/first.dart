import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/first/pages/first_footer.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/first/pages/first_header.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/first/pages/first_label.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/widget/cute_here.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class First extends StatelessWidget {
  final OrderEntities order;
  final ProductEntities product;
  final double unitPrice;
  final double delivery;
  final double grandTotal;
  const First({
    super.key,
    required this.order,
    required this.product,
    required this.delivery,
    required this.unitPrice,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(maxWidth: 380),
        width: 380,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // label -------------
            FirstLabel(order: order, delivery: delivery, unitPrice: unitPrice),
            // cute here ---------
            CuteHere(),
            // invoice header ----------
            FirstHeader(order: order, product: product),
            // invoice body ----
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black)),
                  ),
                  children: [
                    _tableHeader("Prix unit."),
                    _tableHeader("Qté"),
                    _tableHeader("Total"),
                  ],
                ),
                TableRow(
                  children: [
                    _tableCell("${unitPrice.toInt()} Ar"),
                    _tableCell("${order.quantity ?? 1}"),
                    _tableCell(
                      "${unitPrice.toInt() * order.quantity!.toInt()} Ar",
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.h),

            _buildTotalLine(
              "Frais de livraison ==>",
              "${delivery.toInt()} Ar",
              isBold: false,
            ),
            Divider(color: Colors.black),
            _buildTotalLine(
              "TOTAL À PAYER",
              "${grandTotal.toInt()} Ar",
              isBold: true,
            ),
            FirstFooter(),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String text) => Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
        color: Colors.black,
      ),
    ),
  );

  Widget _tableCell(String text) => Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Text(text, style: TextStyle(fontSize: 20.sp, color: Colors.black)),
  );

  Widget _buildTotalLine(String title, String value, {bool isBold = false}) {
    final color = Colors.black;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isBold ? 20.sp : 20.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 20.sp : 20.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
