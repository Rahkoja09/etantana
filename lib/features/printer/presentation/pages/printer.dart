import 'dart:io';
import 'dart:typed_data';

import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/printer/presentation/widgets/action_invoice_panel.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/text/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class Printer extends ConsumerStatefulWidget {
  final OrderEntities order;
  const Printer({super.key, required this.order});

  @override
  ConsumerState<Printer> createState() => _PrinterState();
}

class _PrinterState extends ConsumerState<Printer> {
  ProductEntities product = ProductEntities();
  final ScreenshotController _screenshotController = ScreenshotController();

  double _unitPrice = 0.0;
  double _deliveryCosts = 0.0;

  @override
  void initState() {
    super.initState();
    _deliveryCosts = double.tryParse(widget.order.deliveryCosts ?? '0') ?? 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getProduct();
      _showEditPricesDialog(widget.order.deliveryCosts!);
    });
  }

  Future<void> _getProduct() async {
    await ref
        .read(productControllerProvider.notifier)
        .getProductById(widget.order.productId!);
  }

  Future<void> _exportAndShareInvoice() async {
    try {
      final Uint8List imageBytes = await _screenshotController
          .captureFromWidget(
            buildPrintableInvoice(
              widget.order,
              product,
              _unitPrice,
              _deliveryCosts,
            ),
            context: context,
            delay: const Duration(milliseconds: 100),
          );

      final directory = await getTemporaryDirectory();
      final String fileName = 'facture_${widget.order.id}.png';
      final File imageFile = File('${directory.path}/$fileName');
      await imageFile.writeAsBytes(imageBytes);

      await Share.shareXFiles([
        XFile(imageFile.path),
      ], text: 'Voici la facture de ${widget.order.clientName}');
    } catch (e) {
      debugPrint("Erreur lors de l'exportation : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productControllerProvider);
    ref.listen<ProductState>(productControllerProvider, (prev, next) {
      if (next.product != null && next.isLoading == false) {
        setState(() {
          product = next.product![0];
        });
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: buildPrintableInvoice(
              widget.order,
              product,
              _unitPrice,
              _deliveryCosts,
            ),
          ),
          Positioned(
            bottom: 26.h,
            left: 16.w,
            right: 16.w,
            child: ActionInvoicePanel(
              isLoading: productState.isLoading,
              onChooseModel: () {
                _showEditPricesDialog(widget.order.deliveryCosts!);
              },
              onPrint: () async {
                await _exportAndShareInvoice();
              },
              onSave: () {},
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPricesDialog(String deliveryCosts) {
    final priceController = TextEditingController(text: _unitPrice.toString());
    final deliveryController = TextEditingController(
      text: _deliveryCosts.toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: const Text("Éditer les tarifs"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MediumTitleWithDegree(
                  showDegree: false,
                  title: "Prix unitaire",
                ),
                SimpleInput(
                  textHint: "prix unitaire",
                  iconData: HugeIcons.strokeRoundedMoney02,
                  textEditControlleur: priceController,
                  maxLines: 1,
                ),
                SizedBox(height: 15.h),
                MediumTitleWithDegree(
                  showDegree: false,
                  title: "Frais de livraison",
                ),
                SimpleInput(
                  textHint: "Frais de Liv.",
                  iconData: HugeIcons.strokeRoundedDeliveryTruck02,
                  textEditControlleur: deliveryController,
                  maxLines: 1,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _unitPrice = double.tryParse(priceController.text) ?? 0.0;
                    _deliveryCosts =
                        double.tryParse(deliveryController.text) ?? 0.0;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Valider"),
              ),
            ],
          ),
    );
  }
}

Widget buildPrintableInvoice(
  OrderEntities order,
  ProductEntities product,
  double unitPrice,
  double delivery,
) {
  final color = Colors.black;

  final double totalProducts = unitPrice * (order.quantity ?? 1);
  final double grandTotal = totalProducts + delivery;

  return SingleChildScrollView(
    child: Container(
      width: 380,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  "DESTINATAIRE",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: color,
                  ),
                ),
                Divider(color: Colors.black, thickness: 2),
                SizedBox(height: 8.h),
                Text(
                  order.clientName?.toUpperCase() ?? "CLIENT INCONNU",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Tél: ${order.clientTel ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  order.clientAdrs ?? "À récupérer en magasin",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.sp, color: color),
                ),
                SizedBox(height: 10.h),

                SizedBox(height: 10.h),
                Text(
                  "Prix: ${unitPrice.toInt() * order.quantity!.toInt()} Ar + ${delivery.toInt()} Ar frais",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontStyle: FontStyle.italic,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25.h),
              child: Text(
                "✂ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),

          Text(
            "Ny Mora Vidy",
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "${product.name}",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "Date: ${order.createdAt?.day}/${order.createdAt?.month}/${order.createdAt?.year}",
            style: TextStyle(color: color, fontSize: 20.sp),
          ),

          SizedBox(height: 20.h),

          Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black)),
                ),
                children: [
                  _tableHeader("Prix unit."),
                  _tableHeader("Qté"),
                  _tableHeader("Total"),
                ],
              ),
              TableRow(
                children: [
                  _tableCell("${unitPrice.toInt()} Ar"),
                  _tableCell("${order.quantity ?? 1}"),
                  _tableCell(
                    "${unitPrice.toInt() * order.quantity!.toInt()} Ar",
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 15.h),

          _buildTotalLine(
            "Frais de livraison ==>",
            "${delivery.toInt()} Ar",
            isBold: true,
          ),
          Divider(color: Colors.black),
          _buildTotalLine(
            "TOTAL À PAYER",
            "${grandTotal.toInt()} Ar",
            isBold: true,
          ),

          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Merci de votre achat !",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontStyle: FontStyle.italic,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "NMV : (+261) 38 05 166 86",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Ou scanner ici ===>",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 130,
                width: 130,
                child: Image(
                  image: AssetImage('assets/medias/logos/scan_me.png'),
                ),
              ),
            ],
          ),
          SizedBox(height: 50.h),
        ],
      ),
    ),
  );
}

Widget _tableHeader(String text) => Padding(
  padding: EdgeInsets.symmetric(vertical: 8.h),
  child: Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22.sp,
      color: Colors.black,
    ),
  ),
);

Widget _tableCell(String text) => Padding(
  padding: EdgeInsets.symmetric(vertical: 8.h),
  child: Text(text, style: TextStyle(fontSize: 22.sp, color: Colors.black)),
);

Widget _buildTotalLine(String title, String value, {bool isBold = false}) {
  final color = Colors.black;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isBold ? 22.sp : 20.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 22.sp : 22.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    ),
  );
}
