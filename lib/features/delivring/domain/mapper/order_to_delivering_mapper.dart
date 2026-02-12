import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';

extension OrderToDeliveringMapper on OrderEntities {
  DeliveringEntity toDelivering() {
    return DeliveringEntity(
      orderId: id,
      dateOfDelivering: deliveryDate,
      deliveringAdresse: clientAdrs,
      deliveringPrice: double.tryParse(deliveryCosts ?? "0"),
      deliveringState: [
        {"status": status, "reason": ""},
      ],
      orderProductDetails: productsAndQuantities,
      userDetails: {
        "client_name": clientName,
        "client_tel": clientTel,
        "client_address": clientAdrs,
      },
      status: status,
    );
  }
}
