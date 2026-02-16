import 'dart:io';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/core/utils/tools/calculate_total_product.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/home/presentation/widgets/big_stat_view.dart';
import 'package:e_tantana/features/home/presentation/widgets/stat_number_view.dart';
import 'package:e_tantana/features/nav_bar/presentation/nav_bar.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/widgets/selected_products_preview.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:e_tantana/shared/widget/input/input_number_only_minus.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/loading/loading.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

class CreatePack extends ConsumerStatefulWidget {
  final List<MapData> packComposition;
  const CreatePack({super.key, required this.packComposition});

  @override
  ConsumerState<CreatePack> createState() => _CreatePackState();
}

class _CreatePackState extends ConsumerState<CreatePack> {
  TextEditingController packNameController = TextEditingController();
  TextEditingController priceOfOnePackByUserController =
      TextEditingController();
  int marginPercentage = 0;
  MapData? calculeResult;
  int maxPacksCompletable = 0;
  double unitPurchaseCost = 0.0;

  @override
  Widget build(BuildContext context) {
    final productAction = ref.read(productControllerProvider.notifier);
    final productStates = ref.watch(productControllerProvider);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: SimpleAppbar(title: "Création de Pack", onBack: () {}),
          body: Padding(
            padding: EdgeInsets.all(StylesConstants.spacerContent),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MediumTitleWithDegree(
                    showDegree: false,
                    degree: 1,
                    title: "Les produits dans le Pack".toUpperCase(),
                  ),

                  SelectedProductsPreview(
                    packComposition: widget.packComposition,
                  ),
                  SizedBox(height: 40),
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Nom du Pack",
                  ),
                  SimpleInput(
                    textHint: 'ex : pack cheveux makoa',
                    iconData: HugeIcons.strokeRoundedId,
                    textEditControlleur: packNameController,
                    maxLines: 1,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: InputNumberOnlyMinus(
                          showTitle: true,
                          showDegree: true,
                          degree: 2,
                          initialValue: 0,
                          title: "Pourcentage de marge (%)",
                          onValueChanged: (value) {
                            setState(() {
                              marginPercentage = value;
                            });
                          },
                          minimumValue: -100,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Button(
                      onTap: () {
                        setState(() {
                          calculeResult = calculateTotalIncomeAndPercentage(
                            products: widget.packComposition,
                            margin: marginPercentage,
                            userDefinedPrice: double.tryParse(
                              priceOfOnePackByUserController.text,
                            ),
                          );
                          priceOfOnePackByUserController.text =
                              "${calculeResult?["unit_price_pack"] ?? 0}";
                          maxPacksCompletable =
                              calculeResult?["max_packs_completable"].toInt();
                          unitPurchaseCost =
                              calculeResult?["unit_purchase_cost"];
                        });
                      },
                      btnText: "Caluculer automatiquement",
                      btnColor: Theme.of(context).colorScheme.primary,
                      btnTextColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Prix du Pack (priorité si non vide)",
                  ),
                  SimpleInput(
                    textHint: 'ex : 50000',
                    iconData: HugeIcons.strokeRoundedId,
                    textEditControlleur: priceOfOnePackByUserController,
                    maxLines: 1,
                  ),

                  SizedBox(height: 40),
                  MediumTitleWithDegree(
                    showDegree: false,
                    degree: 1,
                    title: "Analyse financière".toUpperCase(),
                  ),
                  BigStatView(
                    icon: HugeIcons.strokeRoundedMoney04,
                    BigStyleIcon: HugeIcons.strokeRoundedPackageOpen,
                    title: "Apres liquidation sans pack",
                    cycle: "",
                    moneySign: "Ariary",
                    increasePercent: "",
                    value: "${calculeResult?["income_sans_pack"] ?? 0}",
                    themeColor: Colors.grey,
                  ),
                  SizedBox(height: StylesConstants.spacerContent),
                  Row(
                    children: [
                      Expanded(
                        child: StatNumberView(
                          icon: HugeIcons.strokeRoundedInvoice,
                          title: "Sans pack",
                          value:
                              "+${calculeResult?["percent_profit_sans_pack"] ?? 0.0}%",
                        ),
                      ),
                      SizedBox(width: StylesConstants.spacerContent),
                      Expanded(
                        child: StatNumberView(
                          icon: HugeIcons.strokeRoundedPackage03,
                          title: "En pack",
                          value:
                              "+${calculeResult?["percent_profit_avec_pack"] ?? 0.0}%",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: StylesConstants.spacerContent),
                  BigStatView(
                    icon: HugeIcons.strokeRoundedMoney03,
                    BigStyleIcon: HugeIcons.strokeRoundedPackageOutOfStock,
                    themeColor:
                        (calculeResult?["is_loss"] ?? false)
                            ? Colors.red
                            : Colors.green,
                    title: "Apres liquidation en pack",
                    cycle: "",
                    moneySign: "Ariary",
                    increasePercent: "+0%",
                    value: "${calculeResult?["income_avec_pack"] ?? 0}",
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 80,
            color: Colors.white,
            child: BottomContainerButton(
              nextBtnText: "Créer le Pack",
              onBack: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => NavBar(selectedIndex: 1)),
                );
              },
              onValidate: () {
                if (packNameController.text != "" &&
                    priceOfOnePackByUserController.text != "") {
                  ProductEntities myPack = ProductEntities(
                    name: packNameController.text.trim(),
                    isPack: true,
                    packComposition: widget.packComposition,
                    quantity: maxPacksCompletable,
                    futureProduct: false,
                    images: widget.packComposition[0]["image"],
                    sellingPrice: double.tryParse(
                      priceOfOnePackByUserController.text,
                    ),
                    purchasePrice: unitPurchaseCost,
                    type: 'Pack',
                    eId:
                        "Pack_${DateTime.fromMicrosecondsSinceEpoch(1640979000000000)}",
                  );
                  productAction.addProduct(myPack, null);
                } else {
                  setState(() {
                    showToast(
                      context,
                      description: "Veuillez remplir le prix et nom du pack",
                      isError: true,
                      title: "Prix et/ou Nom du pack incomplet",
                    );
                  });
                }
              },
            ),
          ),
        ),
        if (productStates.isLoading) Loading(),
      ],
    );
  }
}
