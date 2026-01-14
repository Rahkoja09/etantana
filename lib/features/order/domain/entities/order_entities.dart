import 'package:equatable/equatable.dart';

class OrderEntities extends Equatable {
  final String? id;
  final DateTime? createdAt;
  final String? status;
  final String? invoiceLink;
  final String? productId;
  final int? quantity;
  final String? details;
  final String? clientName;
  final String? clientTel;
  final String? clientAdrs;
  final String? deliveryCosts;

  const OrderEntities({
    this.id,
    this.createdAt,
    this.status,
    this.invoiceLink,
    this.productId,
    this.quantity,
    this.details,
    this.clientName,
    this.clientTel,
    this.clientAdrs,
    this.deliveryCosts,
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    status,
    invoiceLink,
    productId,
    quantity,
    details,
    clientName,
    clientTel,
    clientAdrs,
  ];
}
