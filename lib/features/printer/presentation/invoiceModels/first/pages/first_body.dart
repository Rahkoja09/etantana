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

  double get _totalProducts => grandTotal - deliveryCost;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: const BoxDecoration(color: Colors.black),
          child: Row(
            children: [
              Expanded(flex: 3, child: _headerText("Article")),
              SizedBox(width: 45, child: _headerText("Qté", center: true)),
              SizedBox(width: 70, child: _headerText("Total", center: true)),
            ],
          ),
        ),

        ...orderList.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          final int price = (item["unit_price"] as num?)?.toInt() ?? 0;
          final int qty = (item["quantity"] as num?)?.toInt() ?? 1;
          final int total = price * qty;

          final variant = item["chosen_variant"] as Map<String, dynamic>?;
          final variantName = variant?['name']?.toString();
          final variantProperty = variant?['property']?.toString();
          final productName = item["product_name"]?.toString() ?? "-";

          final isEven = index % 2 == 0;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
            decoration: BoxDecoration(
              color:
                  isEven ? Colors.transparent : Colors.black.withOpacity(0.04),
              border: const Border(
                bottom: BorderSide(color: Colors.black12, width: 0.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom + variant
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Nonito",
                        ),
                      ),
                      if (variantName != null) ...[
                        Text(
                          _buildVariantLabel(variantName, variantProperty),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black54,
                            fontFamily: "Nonito",
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          "$price Ar / u.",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Nonito",
                          ),
                        ),
                      ] else
                        Text(
                          "$price Ar / u.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black87,
                            fontFamily: "Nonito",
                          ),
                        ),
                    ],
                  ),
                ),

                // Quantité
                SizedBox(
                  width: 32,
                  child: Center(
                    child: Text(
                      "×$qty",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: "Nonito",
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 70,
                  child: Text(
                    "$total Ar",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Nonito",
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        SizedBox(height: 10.h),

        _SummaryLine(
          label: "Sous-total",
          value: "${_totalProducts.toInt()} Ar",
          isBold: true,
        ),

        _SummaryLine(
          label: "Livraison",
          value: "+ ${deliveryCost.toInt()} Ar",
          isBold: true,
          color: Colors.black87,
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Divider(color: Colors.black, thickness: 1.5),
        ),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: const BoxDecoration(color: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOTAL",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "BrunoAceSC",
                  letterSpacing: 1,
                ),
              ),
              Text(
                "${grandTotal.toInt()} Ar",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "BrunoAceSC",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _buildVariantLabel(String name, String? property) {
    if (property != null && property != '-' && property.isNotEmpty) {
      return "$name • $property";
    }
    return name;
  }

  Widget _headerText(String text, {bool center = false}) => Text(
    text,
    textAlign: center ? TextAlign.center : TextAlign.left,
    style: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: "BrunoAceSC",
      letterSpacing: 0.5,
    ),
  );
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _SummaryLine({
    required this.label,
    required this.value,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: c,
              fontFamily: "Nonito",
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: c,
              fontFamily: "Nonito",
            ),
          ),
        ],
      ),
    );
  }
}
