import 'package:flutter/material.dart';

enum DeliveryStatus { pending, validated, delivered, cancelled }

extension DeliveryStatusExtension on DeliveryStatus {
  bool isDelivred(DeliveryStatus status) {
    return status.name.toLowerCase() ==
        DeliveryStatus.validated.name.toLowerCase();
  }

  String get label {
    switch (this) {
      case DeliveryStatus.pending:
        return "En attente";
      case DeliveryStatus.validated:
        return "Validée";
      case DeliveryStatus.delivered:
        return "Livrée";
      case DeliveryStatus.cancelled:
        return "Annulée";
    }
  }

  Color get color {
    switch (this) {
      case DeliveryStatus.validated:
        return Colors.green;
      case DeliveryStatus.delivered:
        return Colors.blue;
      case DeliveryStatus.cancelled:
        return Colors.red;
      case DeliveryStatus.pending:
        return Colors.grey;
    }
  }

  MaterialColor get materialColor {
    if (color is MaterialColor) return color as MaterialColor;
    return Colors.grey;
  }
}
