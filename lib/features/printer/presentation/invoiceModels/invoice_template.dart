import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/printer/presentation/states/invoice_interactions_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class InvoiceTemplate extends StatelessWidget {
  final InvoiceInteractionsStates invoiceData;
  InvoiceTemplate({required this.invoiceData, super.key});

  Widget buildLabel({
    required OrderEntities order,
    required double totalProducts,
    required double deliveryCost,
  });
  Widget buildCuteHere();
  Widget buildHeader({
    required OrderEntities order,
    required List<MapData> orderList,
  });
  Widget buildBody({
    required List<MapData> orderList,
    required double grandTotal,
    required double deliveryCost,
  });
  Widget buildfooter({
    final String societyName = "Ny Mora Vidy",
    final String societyPhoneNumber = "0380516686",
    final String societyQrCodeLinkOrderFile = "assets/medias/logos/scan_me.png",
    final String societyQrCodeSendWhere = "Facebook",
    final String societySlogan = "Manome ny tsara indrindra ho anao",
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(maxWidth: 380),
        width: 380,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          children: [
            buildLabel(
              deliveryCost: invoiceData.deliveryCost,
              order: invoiceData.order!,
              totalProducts: invoiceData.totalProducts,
            ),
            buildCuteHere(),
            buildHeader(
              order: invoiceData.order!,
              orderList: invoiceData.orderList!,
            ),
            buildBody(
              deliveryCost: invoiceData.deliveryCost,
              grandTotal: invoiceData.grandTotal,
              orderList: invoiceData.orderList!,
            ),
            buildfooter(),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
