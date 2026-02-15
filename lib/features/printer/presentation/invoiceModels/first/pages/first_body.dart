import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstBody extends StatelessWidget {
  final List<MapData> orderList;
  final double grandTotal;
  final double deliveryCost;
  const FirstBody({
    super.key,
    required this.orderList,
    required this.grandTotal,
    required this.deliveryCost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12)),
              ),
              children: [
                _tableHeader("Prix unit."),
                _tableHeader("Qté"),
                _tableHeader("Total"),
              ],
            ),
            ...orderList.map((item) {
              final int price = item["unit_price"]?.toInt() ?? 0;
              final int qty = item["quantity"] ?? 1;
              final int total = price * qty;

              return TableRow(
                children: [
                  _tableCell("$price Ar"),
                  _tableCell("$qty"),
                  _tableCell("$total Ar"),
                ],
              );
            }),
          ],
        ),
        SizedBox(height: 15.h),

        _buildTotalLine(
          "Frais de livraison ==>",
          "${deliveryCost.toInt()} Ar",
          isBold: false,
        ),
        Divider(color: Colors.black),
        _buildTotalLine(
          "TOTAL À PAYER",
          "${grandTotal.toInt()} Ar",
          isBold: true,
        ),
      ],
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
