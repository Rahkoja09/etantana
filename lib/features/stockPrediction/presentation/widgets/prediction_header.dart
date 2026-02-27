import 'package:flutter/material.dart';

class PredictionHeader extends StatelessWidget {
  final String name;
  final int daysLeft;

  const PredictionHeader({
    super.key,
    required this.name,
    required this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    bool isUrgent = daysLeft < 7;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color:
                isUrgent
                    ? Colors.red.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            daysLeft > 90 ? "+90j" : "${daysLeft}j restants",
            style: TextStyle(
              color: isUrgent ? Colors.red : Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
