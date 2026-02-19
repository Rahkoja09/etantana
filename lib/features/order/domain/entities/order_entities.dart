import 'package:e_tantana/core/enums/order_status.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:equatable/equatable.dart';

class OrderEntities extends Equatable {
  final String? id;
  final DateTime? createdAt;
  final DeliveryStatus? status;
  final String? invoiceLink;
  final List<MapData>? productsAndQuantities;
  final int? quantity;
  final String? details;
  final String? clientName;
  final String? clientTel;
  final String? clientAdrs;
  final double? deliveryCosts;
  final DateTime? deliveryDate;

  const OrderEntities({
    this.id,
    this.createdAt,
    this.status,
    this.invoiceLink,
    this.productsAndQuantities,
    this.quantity,
    this.details,
    this.clientName,
    this.clientTel,
    this.clientAdrs,
    this.deliveryCosts,
    this.deliveryDate,
  });

  OrderEntities copyWith({
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
    return OrderEntities(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      clientAdrs: clientAdrs ?? this.clientAdrs,
      clientTel: clientTel ?? this.clientTel,
      createdAt: createdAt ?? this.createdAt,
      deliveryCosts: deliveryCosts ?? this.deliveryCosts,
      details: details ?? this.details,
      invoiceLink: invoiceLink ?? this.invoiceLink,
      productsAndQuantities:
          productsAndQuantities ?? this.productsAndQuantities,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      deliveryDate: deliveryDate ?? this.deliveryDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    status,
    invoiceLink,
    productsAndQuantities,
    quantity,
    details,
    clientName,
    clientTel,
    clientAdrs,
    deliveryDate,
  ];
}
