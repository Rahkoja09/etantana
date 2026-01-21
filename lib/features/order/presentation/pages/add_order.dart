import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/nav_bar/presentation/nav_bar.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/order/presentation/states/order_states.dart';
import 'package:e_tantana/features/order/presentation/widget/select_product.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/input/custom_drop_down.dart';
import 'package:e_tantana/shared/widget/input/item_manager_section.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/loading/loading.dart';
import 'package:e_tantana/shared/widget/popup/custom_dialog.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:e_tantana/shared/widget/text/horizontal_divider.dart';
import 'package:e_tantana/shared/widget/text/medium_title_with_degree.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class AddOrder extends ConsumerStatefulWidget {
  const AddOrder({super.key});

  @override
  ConsumerState<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends ConsumerState<AddOrder> {
  int qteProduit = 0;
  String? variantsForServer;
  String? selectedStatus;
  dynamic selectedProductEntity;

  TextEditingController clientName = TextEditingController();
  TextEditingController clientTel = TextEditingController();
  TextEditingController clientAdrs = TextEditingController();
  TextEditingController fraisDeLiv = TextEditingController();

  List<String> statusList = [
    "Validée",
    "Livrée",
    "Annulée",
    "En Attente de Val.",
  ];

  // les ereur -------------
  String? errorClientTel;
  String? errorAdrsClient;
  String? errorDeliveryCosts;

  String? errorProdName;
  String? errorProdQty;
  String? errorStatus;

  bool _validateFields() {
    setState(() {
      // Validation Produit ----------
      errorProdName =
          selectedProductEntity == null ? "Veuillez choisir un produit" : null;
      errorProdQty =
          qteProduit <= 0 ? "La quantité doit être supérieure à 0" : null;
      errorStatus = selectedStatus == null ? "Le status est obligatoire" : null;

      // Validation Client --------------
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
        errorDeliveryCosts == null;
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width - (StylesConstants.spacerContent * 2);

    final orderState = ref.watch(orderControllerProvider);
    final orderAction = ref.read(orderControllerProvider.notifier);
    final productAction = ref.read(productControllerProvider.notifier);

    ref.listen<OrderStates>(orderControllerProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        showDialog(
          context: context,
          builder:
              (context) => ErrorDialog(
                title: "Erreur de création commande.",
                message: next.errorMessage!,
              ),
        );
      }
      if (next.order != null && next.isLoading == false) {
        showToast(
          context,
          title: 'Commande passée.',
          isError: false,
          description:
              "La commande de M./Mm ${clientName.text.trim()} est ajoutée avec succès!",
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
                  // Section Produit
                  SelectProduct(
                    onChanged: (selectionProduct) {
                      setState(() {
                        selectedProductEntity = selectionProduct;
                      });
                    },
                  ),
                  ShowInputError(message: errorProdName),

                  SizedBox(height: 20.h),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        StylesConstants.borderRadius,
                      ),
                    ),
                    child: NumberInput(
                      value: qteProduit,
                      title: "Quantité(s) Commandé *",
                      onValueChanged: (qte) {
                        setState(() {
                          qteProduit = qte;
                        });
                      },
                    ),
                  ),
                  ShowInputError(message: errorProdQty),

                  SizedBox(height: 20.h),
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 2,
                    title: "Status de la commande",
                  ),

                  CustomDropdown(
                    iconData: HugeIcons.strokeRoundedCheckList,
                    onChanged: (val) {
                      setState(() {
                        selectedStatus = val;
                      });
                    },
                    items: statusList,
                    textHint: "Selectionner",
                    value: selectedStatus,
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

                  SizedBox(height: 10.h),
                  HorizontalDivider(
                    width: width,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 20.h),

                  // Section Client
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
                  SimpleInput(
                    textHint: "ex: 0343032386",
                    iconData: HugeIcons.strokeRoundedCall02,
                    textEditControlleur: clientTel,
                    maxLines: 1,
                  ),
                  ShowInputError(message: errorClientTel),

                  SizedBox(height: 20.h),
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Adresse de Livraison",
                  ),
                  SimpleInput(
                    textHint: "ex: Analakely - Commune",
                    iconData: HugeIcons.strokeRoundedMapsLocation01,
                    textEditControlleur: clientAdrs,
                    maxLines: 1,
                  ),
                  ShowInputError(message: errorAdrsClient),

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

                  SizedBox(height: 30.h),

                  BottomContainerButton(
                    prevBtnText: "Annuler",
                    nextBtnText: "Valider",
                    onBack: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => NavBar(selectedIndex: 0),
                        ),
                      );
                    },
                    onValidate: () async {
                      if (_validateFields()) {
                        final orderData = OrderEntities(
                          clientAdrs: clientAdrs.text.trim(),
                          clientName: clientName.text.trim(),
                          clientTel: clientTel.text.trim(),
                          deliveryCosts: fraisDeLiv.text.trim(),
                          details: variantsForServer,
                          productId: selectedProductEntity.id,
                          quantity: qteProduit,
                          status: selectedStatus,
                        );
                        await orderAction.insertOrder(orderData);

                        final updates = selectedProductEntity.copyWith(
                          quantity:
                              (selectedProductEntity.quantity - qteProduit),
                        );
                        await productAction.updateProduct(updates);
                        await productAction.researchProduct(null);

                        // réinitialiser les inputs -------------
                        setState(() {
                          qteProduit = 0;
                        });
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
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          if (orderState.isLoading) Loading(),
        ],
      ),
    );
  }
}
