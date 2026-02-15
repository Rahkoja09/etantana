import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/first/pages/first_body.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/first/pages/first_footer.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/first/pages/first_header.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/first/pages/first_label.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/invoice_template.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/widget/cute_here.dart';
import 'package:flutter/material.dart';

class First extends InvoiceTemplate {
  First({required super.invoiceData});

  @override
  Widget buildBody({
    required List<MapData> orderList,
    required double grandTotal,
    required double deliveryCost,
  }) {
    return FirstBody(
      orderList: orderList,
      deliveryCost: deliveryCost,
      grandTotal: grandTotal,
    );
  }

  @override
  Widget buildCuteHere() {
    return CuteHere();
  }

  @override
  Widget buildHeader({
    required OrderEntities order,
    required List<MapData> orderList,
  }) {
    return FirstHeader(order: order, orderList: orderList);
  }

  @override
  Widget buildLabel({
    required OrderEntities order,
    required double totalProducts,
    required double deliveryCost,
  }) {
    return FirstLabel(
      order: order,
      delivery: deliveryCost,
      totalProducts: totalProducts,
    );
  }

  @override
  Widget buildfooter({
    String societyName = "nmv",
    String societyPhoneNumber = "0380516686",
    String societyQrCodeLinkOrderFile = "assets/medias/logos/scan_me.png",
    String societyQrCodeSendWhere = "Facebook",
    String societySlogan = "Manome ny tsara indrindra ho anao",
  }) {
    return FirstFooter(
      societyName: societyName,
      societyPhoneNumber: societyPhoneNumber,
      societyQrCodeLinkOrderFile: societyQrCodeLinkOrderFile,
      societySlogan: societySlogan,
      societyQrCodeSendWhere: societyQrCodeSendWhere,
    );
  }
}
