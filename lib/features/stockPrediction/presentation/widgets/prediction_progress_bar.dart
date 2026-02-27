import 'package:flutter/material.dart';

class PredictionProgressBar extends StatelessWidget {
  final double pressure;

  const PredictionProgressBar({super.key, required this.pressure});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green;
    if (pressure > 0.8) {
      statusColor = Colors.red;
    } else if (pressure > 0.5) {
      statusColor = Colors.orange;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: pressure,
        minHeight: 8,
        backgroundColor: statusColor.withOpacity(0.1),
        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
      ),
    );
  }
}
