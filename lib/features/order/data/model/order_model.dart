import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';

class OrderModel extends OrderEntities {
  const OrderModel({
    super.id,
    super.createdAt,
    super.quantity,
    super.status,
    super.invoiceLink,
    super.productId,
    super.details,
    super.clientName,
    super.clientTel,
    super.clientAdrs,
    super.deliveryCosts,
  });

  factory OrderModel.fromMap(MapData data) {
    return OrderModel(
      id: data['id'],
      status: data['status'],
      quantity: data["quantity"],
      createdAt: DateTime.parse(data['created_at']),
      invoiceLink: data['invoice_link'],
      productId: data['product_id'],
      clientName: data['client_name'],
      clientTel: data['client_tel'],
      clientAdrs: data['client_adrs'],
      details: data['details'],
      deliveryCosts: data['delivery_costs'],
    );
  }

  MapData toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'status': status,
      'quantity': quantity,
      'invoice_link': invoiceLink,
      'product_id': productId,
      'client_name': clientName,
      'client_tel': clientTel,
      'client_adrs': clientAdrs,
      'details': details,
      'delivery_costs': deliveryCosts,
    };
  }

  factory OrderModel.fromEntity(OrderEntities entity) {
    return OrderModel(
      id: entity.id,
      details: entity.details,
      quantity: entity.quantity,
      createdAt: entity.createdAt,
      status: entity.status,
      productId: entity.productId,
      clientName: entity.clientName,
      clientTel: entity.clientTel,
      clientAdrs: entity.clientAdrs,
      invoiceLink: entity.invoiceLink,
      deliveryCosts: entity.deliveryCosts,
    );
  }

  OrderModel copyWith({
    String? id,
    DateTime? createdAt,
    String? status,
    String? invoiceLink,
    String? productId,
    int? quantity,
    String? details,
    String? clientName,
    String? clientTel,
    String? clientAdrs,
    String? deliveryCosts,
  }) {
    return OrderModel(
      id: id ?? this.id,
      clientAdrs: clientAdrs ?? this.clientAdrs,
      clientName: clientName ?? this.clientName,
      clientTel: clientTel ?? this.clientTel,
      createdAt: createdAt ?? this.createdAt,
      details: details ?? this.details,
      invoiceLink: invoiceLink ?? this.invoiceLink,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      deliveryCosts: deliveryCosts ?? this.deliveryCosts,
    );
  }
}
