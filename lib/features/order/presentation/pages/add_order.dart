import 'package:e_tantana/core/enums/order_status.dart';
import 'package:e_tantana/features/delivring/presentation/controller/delivering_controller.dart';
import 'package:e_tantana/features/printer/presentation/pages/printer_view.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/shared/widget/input/date_input.dart';
import 'package:e_tantana/shared/widget/input/input_number_only_minus.dart';
import 'package:e_tantana/shared/widget/input/swith_selector.dart';
import 'package:e_tantana/shared/widget/others/mini_text_card.dart';
import 'package:e_tantana/shared/widget/others/price_viewer.dart';
import 'package:e_tantana/shared/widget/others/separator_background.dart';
import 'package:e_tantana/shared/widget/title/title_with_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/home/presentation/controller/dashboard_controller.dart';
import 'package:e_tantana/features/nav_bar/presentation/nav_bar.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/order/presentation/widget/multiple_product_view_order.dart';
import 'package:e_tantana/features/order/presentation/widget/select_product.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/input/custom_drop_down.dart';
import 'package:e_tantana/shared/widget/input/item_manager_section.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/loading/loading.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';

class AddOrder extends ConsumerStatefulWidget {
  List<MapData>? orderListToOrderWithQuantity;
  final List<ProductEntities?>? productToOrder;
  AddOrder({super.key, this.productToOrder, this.orderListToOrderWithQuantity});

  @override
  ConsumerState<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends ConsumerState<AddOrder> {
  int qteProduit = 1;
  String? variantsForServer;
  DeliveryStatus? selectedStatus;
  List<ProductEntities?>? selectedProductEntity;
  String deliveryCity = "Antananarivo";
  DateTime? deliveryDate;
  TextEditingController clientName = TextEditingController();
  TextEditingController clientTel = TextEditingController();
  TextEditingController clientAdrs = TextEditingController();
  TextEditingController fraisDeLiv = TextEditingController();
  String countryCallCode = "+261";

  @override
  void initState() {
    super.initState();
    if (widget.productToOrder != null) {
      setState(() {
        selectedProductEntity = widget.productToOrder;
      });
    }
    if (widget.productToOrder?.length == 1) {
      setState(() {
        qteProduit = widget.orderListToOrderWithQuantity?[0]["quantity"] ?? 1;
      });
    }
  }

  // les ereur -------------
  String? errorClientTel;
  String? errorAdrsClient;
  String? errorDeliveryCosts;
  String? errorDeliveryDate;
  String? errorProdName;
  String? errorProdQty;
  String? errorStatus;

  Future<void> updateHomeDashboard() async {
    await ref
        .read(dashboardStatsControllerProvider.notifier)
        .getDashboardStats();
  }

  bool _validateFields() {
    setState(() {
      // Validation Produit ----------

      errorProdName =
          selectedProductEntity == null ? "Veuillez choisir un produit" : null;

      errorStatus = selectedStatus == null ? "Le status est obligatoire" : null;

      // Validation Client --------------
      errorDeliveryDate =
          deliveryDate == null ? "Veuillez choisir la date de livraison" : null;
      errorClientTel =
          clientTel.text.isEmpty ? "Le Numéro client est obligatoire" : null;
      errorAdrsClient =
          clientAdrs.text.isEmpty ? "L'adresse client est obligatoire" : null;
      errorDeliveryCosts =
          fraisDeLiv.text.isEmpty
              ? "Les frais de livraison sont obligatoires"
              : null;
    });

    return errorProdName == null &&
        errorProdQty == null &&
        errorStatus == null &&
        errorClientTel == null &&
        errorAdrsClient == null &&
        errorDeliveryCosts == null &&
        errorDeliveryDate == null;
  }

  double calculateTotal(
    List<ProductEntities?> actualProducts,
    List<MapData> orderListe,
  ) {
    double total = 0;
    for (var item in orderListe) {
      final String currentId = item["id"];
      final int quantity = item["quantity"];
      for (var product in actualProducts) {
        if (product!.id == currentId) {
          final price = (product.sellingPrice ?? 0).toDouble();
          setState(() {
            total += price * quantity;
          });
          break;
        }
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderControllerProvider);
    final orderAction = ref.read(orderControllerProvider.notifier);
    final productAction = ref.read(productControllerProvider.notifier);
    final deliveryAction = ref.read(deliveringControllerProvider.notifier);
    final stockPredictionAction = ref.read(
      stockPredictionControllerProvider.notifier,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: SimpleAppbar(
        title: "Créer une commande",
        onBack: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => NavBar(selectedIndex: 1)),
          );
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(StylesConstants.spacerContent),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedProductEntity == null ||
                      selectedProductEntity!.length == 1)
                    SeparatorBackground(
                      child: SelectProduct(
                        selectedProduct: selectedProductEntity?[0],
                        onChanged: (selectionProduct) {
                          setState(() {
                            selectedProductEntity = [selectionProduct];
                            widget.orderListToOrderWithQuantity = [
                              {
                                "id": selectionProduct!.id,
                                "quantity": qteProduit,
                                "unit_price": selectionProduct.sellingPrice,
                                "product_name": selectionProduct.name,
                                "purchase_price":
                                    selectionProduct.purchasePrice,
                              },
                            ];
                          });
                        },
                      ),
                    ),
                  if (selectedProductEntity != null &&
                      selectedProductEntity!.length > 1) ...[
                    Container(
                      padding: EdgeInsets.all(StylesConstants.spacerContent),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          StylesConstants.borderRadius,
                        ),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.2),
                          width: 0.7,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.08),
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.20),
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.30),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MediumTitleWithDegree(
                            showDegree: false,
                            title: "Détails du panier",
                          ),
                          Row(
                            children: [
                              MiniTextCard(
                                text:
                                    "${calculateTotal(selectedProductEntity!, widget.orderListToOrderWithQuantity!)} Ar",
                                icon: HugeIcons.strokeRoundedMoney03,
                              ),
                              SizedBox(width: 5),
                              MiniTextCard(
                                text:
                                    "${widget.productToOrder!.length} Articles",
                                icon: HugeIcons.strokeRoundedShoppingCart01,
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          MediumTitleWithDegree(
                            showDegree: false,
                            title: "Les Produits",
                          ),
                          MultipleProductViewOrder(
                            productsToOrder: selectedProductEntity!,
                          ),
                        ],
                      ),
                    ),
                  ],

                  ShowInputError(message: errorProdName),

                  SizedBox(height: 10.h),

                  SeparatorBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWithIcon(
                          boldTitle: true,
                          icon: Icons.shopping_bag,
                          title: "Détails de la commande",
                          themeColor: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(height: 20.h),

                        if (widget.productToOrder == null ||
                            widget.productToOrder!.length == 1)
                          Row(
                            children: [
                              Expanded(
                                child: InputNumberOnlyMinus(
                                  minimumValue: 0,
                                  onValueChanged: (newValue) {
                                    setState(() {
                                      qteProduit = newValue;
                                      widget.orderListToOrderWithQuantity = [
                                        {
                                          "id": selectedProductEntity?[0]?.id,
                                          "quantity": newValue,
                                          "unit_price":
                                              selectedProductEntity?[0]
                                                  ?.sellingPrice,
                                          "product_name":
                                              selectedProductEntity?[0]?.name,
                                          "purchase_price":
                                              selectedProductEntity?[0]
                                                  ?.purchasePrice,
                                        },
                                      ];
                                    });
                                  },
                                  title: "Quantité(s)",
                                  showDegree: false,
                                  showTitle: true,
                                  initialValue: qteProduit.toInt(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: PriceViewer(
                                  showTitle: true,
                                  title: "Prix unitaire",
                                  showDegree: false,
                                  moneySign: "Ar",
                                  price:
                                      selectedProductEntity?[0]?.sellingPrice ??
                                      0.0,
                                ),
                              ),
                            ],
                          ),

                        ShowInputError(message: errorProdQty),

                        SizedBox(height: 20.h),
                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 2,
                          title: "Status de la commande",
                        ),
                        SwithSelector(
                          themeColor: Theme.of(context).colorScheme.primary,
                          options: DeliveryStatus.values,
                          initialValue: DeliveryStatus.pending,
                          labelBuilder: (status) => status.label,
                          onChanged: (newValue) {
                            setState(() {
                              selectedStatus = newValue;
                            });
                          },
                        ),

                        ShowInputError(message: errorStatus),

                        SizedBox(height: 20.h),
                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 2,
                          title: "Détails",
                        ),
                        ItemManagerSection(
                          onChanged: (variante) {
                            setState(() {
                              variantsForServer = variante;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),

                  SeparatorBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWithIcon(
                          boldTitle: true,
                          icon: Icons.person,
                          title: "Informations client",
                          themeColor: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(height: 20.h),

                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 1,
                          title: "Nom Client",
                        ),
                        SimpleInput(
                          textHint: "ex: Rakoto",
                          iconData: HugeIcons.strokeRoundedId,
                          textEditControlleur: clientName,
                          maxLines: 1,
                        ),

                        SizedBox(height: 20.h),
                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 1,
                          title: "N. Téléphone Client",
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomDropdown(
                                textHint: "+261",
                                iconData: HugeIcons.strokeRoundedContactBook,
                                items: ["+261", "..."],
                                onChanged: (contryCallCode) {
                                  setState(() {
                                    countryCallCode = countryCallCode;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 5,
                              child: SimpleInput(
                                textHint: "ex: 343032386 (sans 0)",
                                iconData: HugeIcons.strokeRoundedCall02,
                                textEditControlleur: clientTel,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        ShowInputError(message: errorClientTel),

                        SizedBox(height: 20.h),
                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 1,
                          title: "Adresse de Livraison",
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomDropdown(
                                value: deliveryCity,
                                textHint: "ville",
                                iconData: HugeIcons.strokeRoundedMaps,
                                items: [
                                  "Antananarivo",
                                  "Fianarantsoa",
                                  "Toamasina",
                                  "Antsirabe",
                                  'Diego',
                                  "Mahajanga",
                                ],
                                onChanged: (selectedCity) {
                                  setState(() {
                                    deliveryCity = selectedCity!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: SimpleInput(
                                textHint: "ex: Analakely",
                                iconData: HugeIcons.strokeRoundedMapsLocation01,
                                textEditControlleur: clientAdrs,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        ShowInputError(message: errorAdrsClient),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),

                  SeparatorBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWithIcon(
                          boldTitle: true,
                          icon: Icons.delivery_dining_sharp,
                          title: "Logistiques",
                          themeColor: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(height: 20.h),
                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 1,
                          title: "Frais de Livraison",
                        ),
                        SimpleInput(
                          textHint: "ex: 4000",
                          iconData: HugeIcons.strokeRoundedDeliveryTruck02,
                          textEditControlleur: fraisDeLiv,
                          maxLines: 1,
                        ),
                        ShowInputError(message: errorDeliveryCosts),
                        SizedBox(height: 20.h),
                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 1,
                          title: "Date de Livraison",
                        ),
                        DateInput(
                          iconData: HugeIcons.strokeRoundedCalendarAdd01,
                          textHint: "Date de livraison",
                          isRange: false,
                          onDateSelected: (selectedDate) {
                            setState(() {
                              deliveryDate = selectedDate;
                            });
                          },
                        ),
                        ShowInputError(message: errorDeliveryDate),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
          if (orderState.isLoading) Loading(),
        ],
      ),

      bottomNavigationBar: BottomContainerButton(
        nextBtnText: "Créer",
        onBack: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => NavBar(selectedIndex: 0)),
          );
        },
        onValidate: () async {
          if (_validateFields()) {
            print("entré ici");
            final firstProduct = selectedProductEntity?.firstOrNull;

            if (firstProduct == null) {
              setState(() => errorProdName = "Veuillez choisir un produit");
              return;
            }

            if (widget.orderListToOrderWithQuantity != null &&
                widget.orderListToOrderWithQuantity!.length > 1) {
              qteProduit = 0;
              for (var order in widget.orderListToOrderWithQuantity!) {
                qteProduit += (order["quantity"] as num).toInt();
              }
            }

            final orderData = OrderEntities(
              clientAdrs: "${deliveryCity.trim()} - ${clientAdrs.text.trim()}",
              clientName: clientName.text.trim(),
              clientTel: " ${countryCallCode.trim()}${clientTel.text.trim()}",
              deliveryCosts: double.tryParse(fraisDeLiv.text.trim()),
              details: variantsForServer,
              productsAndQuantities: widget.orderListToOrderWithQuantity,
              quantity: qteProduit,
              status: selectedStatus,
              deliveryDate: deliveryDate,
            );

            await orderAction.placeCompleteOrder(orderData);
            await productAction.researchProduct(null);
            await deliveryAction.searchDelivering(null);
            await stockPredictionAction.refresh();

            // réinitialiser les inputs -------------
            qteProduit = 0;
            variantsForServer = null;
            selectedStatus = null;
            selectedProductEntity;
            clientName.text = "";
            clientTel.text = "";
            clientAdrs.text = "";
            fraisDeLiv.text = "";
          } else {
            debugPrint("Formulaire invalide");
          }
        },
      ),
    );
  }
}
