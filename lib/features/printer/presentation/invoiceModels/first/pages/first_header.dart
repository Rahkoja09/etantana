import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstHeader extends StatelessWidget {
  final OrderEntities order;
  final List<MapData> orderList;

  const FirstHeader({super.key, required this.order, required this.orderList});

  String _formatDate(DateTime? date) {
    if (date == null) return "—";
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.black;
    final orderId = order.id?.substring(0, 8).toUpperCase() ?? "——";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: const BoxDecoration(color: color),
                child: Text(
                  "FACTURE",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: Colors.white,
                    fontFamily: "BrunoAceSC",
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2),
              ),
              child: Text(
                "#$orderId",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: "BrunoAceSC",
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        const Divider(color: Colors.black, thickness: 1),
        const SizedBox(height: 6),

        _InfoRow(label: "Commande", value: _formatDate(order.createdAt)),
        _InfoRow(label: "Livraison", value: _formatDate(order.deliveryDate)),

        const SizedBox(height: 6),
        const Divider(color: Colors.black54, thickness: 0.5),
        const SizedBox(height: 6),

        Row(
          children: [
            Text(
              "M/Me : ",
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: "Nonito",
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                order.clientName!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "BrunoAceSC",
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),
        const Divider(color: Colors.black, thickness: 1.5),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: "Nonito",
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: "Nonito",
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
