import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:flutter/material.dart';

@immutable
class InvoiceInteractionsStates {
  final double totalProducts;
  final List<MapData>? orderList;
  final OrderEntities? order;
  final double deliveryCost;
  final double grandTotal;

  const InvoiceInteractionsStates({
    this.deliveryCost = 0.0,
    this.grandTotal = 0.0,
    this.orderList,
    this.order,
    this.totalProducts = 0.0,
  });

  InvoiceInteractionsStates copyWith({
    double? totalProducts,
    List<MapData>? orderList,
    OrderEntities? order,
    double? deliveryCost,
    double? grandTotal,
  }) {
    return InvoiceInteractionsStates(
      order: order ?? this.order,
      orderList: orderList ?? this.orderList,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      grandTotal: grandTotal ?? this.grandTotal,
      totalProducts: totalProducts ?? this.totalProducts,
    );
  }
}
