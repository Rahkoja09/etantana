import 'package:e_tantana/core/enums/order_status.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';

class OrderModel extends OrderEntities {
  const OrderModel({
    super.id,
    super.createdAt,
    super.quantity,
    super.status,
    super.invoiceLink,
    super.productsAndQuantities,
    super.details,
    super.clientName,
    super.clientTel,
    super.clientAdrs,
    super.deliveryCosts,
    super.deliveryDate,
  });

  factory OrderModel.fromEntity(OrderEntities entity) {
    return OrderModel(
      id: entity.id,
      details: entity.details,
      quantity: entity.quantity,
      createdAt: entity.createdAt,
      status: entity.status,
      productsAndQuantities: entity.productsAndQuantities,
      clientName: entity.clientName,
      clientTel: entity.clientTel,
      clientAdrs: entity.clientAdrs,
      invoiceLink: entity.invoiceLink,
      deliveryCosts: entity.deliveryCosts,
      deliveryDate: entity.deliveryDate,
    );
  }

  factory OrderModel.fromMap(MapData data) {
    return OrderModel(
      id: data['id'],
      status: _mapStringToStatus(data['status']),
      quantity: data["quantity"],
      createdAt: DateTime.parse(data['created_at']),
      invoiceLink: data['invoice_link'],
      productsAndQuantities:
          data['products_and_quantities'] != null
              ? (data['products_and_quantities'] as List)
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList()
              : null,
      clientName: data['client_name'],
      clientTel: data['client_tel'],
      clientAdrs: data['client_adrs'],
      details: data['details'],
      deliveryCosts: data['delivery_costs'].toDouble(),
      deliveryDate:
          data["delivery_date"] != null
              ? DateTime.parse(data["delivery_date"])
              : null,
    );
  }

  MapData toMap() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'status': status?.name,
      'quantity': quantity,
      'invoice_link': invoiceLink,
      'products_and_quantities': productsAndQuantities,
      'client_name': clientName,
      'client_tel': clientTel,
      'client_adrs': clientAdrs,
      'details': details,
      'delivery_costs': deliveryCosts,
      'delivery_date': deliveryDate?.toIso8601String(),
    };
  }

  static DeliveryStatus _mapStringToStatus(String? statusName) {
    try {
      return DeliveryStatus.values.byName(statusName!);
    } catch (_) {
      return DeliveryStatus.pending;
    }
  }

  @override
  OrderModel copyWith({
    String? id,
    DateTime? createdAt,
    DeliveryStatus? status,
    String? invoiceLink,
    List<MapData>? productsAndQuantities,
    int? quantity,
    String? details,
    String? clientName,
    String? clientTel,
    String? clientAdrs,
    double? deliveryCosts,
    DateTime? deliveryDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      status: status ?? this.status,
      // ... reste des champs
      clientAdrs: clientAdrs ?? this.clientAdrs,
      clientName: clientName ?? this.clientName,
      clientTel: clientTel ?? this.clientTel,
      createdAt: createdAt ?? this.createdAt,
      details: details ?? this.details,
      invoiceLink: invoiceLink ?? this.invoiceLink,
      productsAndQuantities:
          productsAndQuantities ?? this.productsAndQuantities,
      quantity: quantity ?? this.quantity,
      deliveryCosts: deliveryCosts ?? this.deliveryCosts,
      deliveryDate: deliveryDate ?? this.deliveryDate,
    );
  }
}
