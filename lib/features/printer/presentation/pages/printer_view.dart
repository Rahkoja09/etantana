import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/features/nav_bar/presentation/nav_bar.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/printer/presentation/providers/interaction_invoice_data_provider.dart';
import 'package:e_tantana/features/printer/presentation/providers/invoice_model_list_provider.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/popup/show_custom_popup.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:e_tantana/shared/widget/text/vertical_custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:screenshot/screenshot.dart';

class PrinterView extends ConsumerStatefulWidget {
  final OrderEntities order;
  const PrinterView({super.key, required this.order});

  @override
  ConsumerState createState() => _PrinterViewState();
}

class _PrinterViewState extends ConsumerState<PrinterView> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final medias = sl<MediaServices>();

  double _deliveryCosts = 0;

  @override
  void initState() {
    super.initState();
    _deliveryCosts = double.tryParse(widget.order.deliveryCosts ?? '0') ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final allInvoiceModelsState = ref.watch(allInvoiceModelsProvider);
    return Scaffold(
      appBar: SimpleAppbar(
        title: "Facturation commande",
        onBack: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const NavBar(selectedIndex: 2)),
          );
        },
      ),
      body: Stack(
        children: [
          _buildGridBackground(),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                trackpadScrollCausesScale: true,
                minScale: 0.1,
                maxScale: 4.0,
                child: allInvoiceModelsState[0].getModel,
              ),
            ),
          ),

          Positioned(
            bottom: 10.h,
            left: 10.w,
            right: 10.w,
            child: _buildToolbar(
              allInvoiceModelsState[0].getModel,
              widget.order,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: CustomPaint(painter: GridPainter()),
    );
  }

  Widget _buildToolbar(Widget invoiceModel, OrderEntities order) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(StylesConstants.spacerContent - 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildToolbarButton(Icons.edit, "Modifier", () {
              _showEditPricesDialog(widget.order.deliveryCosts!);
            }),
            VerticalCustomDivider(
              height: 20,
              width: 1,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            _buildToolbarButton(Icons.save_alt, "Exporter", () {
              medias.screenshotAndShareMedia(
                context,
                order.id!,
                order.clientName!,
                _screenshotController,
                invoiceModel,
              );
            }),
            VerticalCustomDivider(
              height: 20,
              width: 1,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            _buildToolbarButton(Icons.print, "Imprimer", () {
              medias.screenshotAndShareMedia(
                context,
                order.id!,
                order.clientName!,
                _screenshotController,
                invoiceModel,
              );
            }),
            VerticalCustomDivider(
              height: 20,
              width: 1,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            _buildToolbarButton(Icons.open_in_new, "Ouvrir avec", () {
              medias.screenshotAndShareMedia(
                context,
                order.id!,
                order.clientName!,
                _screenshotController,
                invoiceModel,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyles.bodySmall(context: context, fontSize: 10),
          ),
        ],
      ),
    );
  }

  void _showEditPricesDialog(String deliveryCosts) {
    final deliveryController = TextEditingController(
      text: _deliveryCosts.toString(),
    );
    final interactionInvoiceDataAction = ref.read(
      interactionInvoiceDataNotifierProvider.notifier,
    );

    showCustomPopup(
      title: "Ajouter les tarifs",
      context: context,
      isError: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediumTitleWithDegree(showDegree: false, title: "Frais de livraison"),
          SimpleInput(
            textHint: "Frais de Liv.",
            iconData: HugeIcons.strokeRoundedDeliveryTruck02,
            textEditControlleur: deliveryController,
            maxLines: 1,
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Button(
                onTap: () => Navigator.pop(context),
                btnText: "Annuler",
                enableNoBackground: true,
                btnTextColor: Theme.of(context).colorScheme.onSurface,
                btnColor: Theme.of(context).colorScheme.onSurface,
              ),
              Button(
                onTap: () {
                  setState(() {
                    _deliveryCosts =
                        double.tryParse(deliveryController.text) ?? 0.0;
                    interactionInvoiceDataAction.setDeliveryCost(
                      _deliveryCosts,
                    );
                  });
                  Navigator.pop(context);
                },
                btnText: "Valider",
                btnTextColor: Colors.white,
                btnColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
      description: 'Prix unitaire prod. & frais de livraison',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withValues(alpha: 0.8)
          ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
