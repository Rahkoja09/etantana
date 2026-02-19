import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/printer/presentation/states/invoice_interactions_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InteractionInvoiceDataProvider
    extends Notifier<InvoiceInteractionsStates> {
  @override
  InvoiceInteractionsStates build() {
    return const InvoiceInteractionsStates();
  }

  void initOrder(OrderEntities order) {
    final orderList = order.productsAndQuantities ?? [];

    double totalProducts = 0.0;
    for (var item in orderList) {
      final price = (item["unit_price"] as num?)?.toDouble() ?? 0.0;
      final qty = (item["quantity"] as num?)?.toInt() ?? 1;
      totalProducts += price * qty;
    }
    final delivery = order.deliveryCosts ?? 0.0;

    state = state.copyWith(
      order: order,
      orderList: orderList,
      totalProducts: totalProducts,
      deliveryCost: delivery,
      grandTotal: totalProducts + delivery,
    );
  }

  void setTotal(List<MapData> orderList) {
    double totalProducts = 0.0;
    for (int i = 0; i < orderList.length; i++) {
      totalProducts +=
          orderList[i]["unit_price"] * (orderList[i]["quantity"] ?? 1);
    }
    state = state.copyWith(totalProducts: totalProducts);
  }

  void setGrandTotal(List<MapData> orderList, double deliveryCosts) {
    double totalProducts = 0.0;
    for (int i = 0; i < orderList.length; i++) {
      totalProducts +=
          orderList[i]["unit_price"] * (orderList[i]["quantity"] ?? 1);
    }
    final double grandTotal = totalProducts + deliveryCosts;
    state = state.copyWith(grandTotal: grandTotal);
  }

  void setDeliveryCost(double value) {
    state = state.copyWith(deliveryCost: value);
  }

  void setOrder(OrderEntities order) {
    state = state.copyWith(order: order);
  }

  void setOrderList(List<MapData> orderList) {
    state = state.copyWith(orderList: orderList);
  }
}

final interactionInvoiceDataNotifierProvider =
    NotifierProvider<InteractionInvoiceDataProvider, InvoiceInteractionsStates>(
      () {
        return InteractionInvoiceDataProvider();
      },
    );
