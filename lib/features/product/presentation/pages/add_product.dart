import 'dart:io';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/input/custom_toggle.dart';
import 'package:e_tantana/shared/widget/others/separator_background.dart';
import 'package:e_tantana/shared/widget/popup/confirmation_dialogue.dart';
import 'package:e_tantana/shared/widget/mediaView/image_picker_display.dart';
import 'package:e_tantana/shared/widget/input/custom_drop_down.dart';
import 'package:e_tantana/shared/widget/input/item_manager_section.dart';
import 'package:e_tantana/shared/widget/loading/loading.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/popup/transparent_background_pop_up.dart';
import 'package:e_tantana/shared/widget/title/title_with_explaination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class AddProduct extends ConsumerStatefulWidget {
  final bool isFutureProduct;
  final ProductEntities? productToEdit;
  const AddProduct({
    super.key,
    required this.isFutureProduct,
    this.productToEdit,
  });

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  // les inputs ----------------
  dynamic _productImage;
  TextEditingController codeProduitInput = TextEditingController();
  TextEditingController nomProduitInput = TextEditingController();
  TextEditingController descProduitInput = TextEditingController();
  TextEditingController purchasePriceInput = TextEditingController();
  TextEditingController sellingPriceInput = TextEditingController();
  int qteProduit = 0;
  String? selectedType;
  List<Map<String, dynamic>> _variants = [];
  List<File?> _variantImages = [];
  bool? isFutureProduct;

  @override
  void initState() {
    super.initState();
    isFutureProduct = widget.isFutureProduct;
    final productToEdit = widget.productToEdit;
    if (productToEdit != null) {
      fillAllInputControllerWhenEdit(productToEdit);
    }
  }

  void fillAllInputControllerWhenEdit(ProductEntities productToEdit) {
    nomProduitInput.text = productToEdit.name ?? "";
    codeProduitInput.text = productToEdit.eId ?? "";
    descProduitInput.text = productToEdit.description ?? "";
    purchasePriceInput.text = productToEdit.purchasePrice?.toString() ?? "";
    sellingPriceInput.text = productToEdit.sellingPrice?.toString() ?? "";
    qteProduit = productToEdit.quantity ?? 0;
    selectedType = productToEdit.type;
    isFutureProduct = productToEdit.futureProduct ?? false;
    _productImage = productToEdit.images;
    _variants = productToEdit.variant ?? [];
  }

  final _mediaService = sl<MediaServices>();
  bool showPopUp = false;

  List<String> typeOfProductList = [
    'Pack',
    "Électronique & High-Tech",
    "Beauté et Esthétique",
    "Consommables & Alimentation",
    "Mode & Vêtements",
    "Chaussures & Baskets",
    "Sacs & Maroquinerie",
    "Accessoires Téléphone",
    "Maison & Décoration",
    "Électroménager",
    "Sport & Fitness",
    "Bébés & Enfants",
    "Bijoux & Accessoires",
    "Autres",
  ];

  // les ereur -------------
  String? errorName;
  String? errorQuantity;

  bool _validateFields() {
    setState(() {
      errorName =
          nomProduitInput.text.isEmpty
              ? "Le nom du produit est obligatoire"
              : null;

      errorQuantity =
          qteProduit <= 0 ? "La quantité produit est obligatoire" : null;
    });

    return errorName == null && errorQuantity == null;
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productControllerProvider);
    final productAction = ref.read(productControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    final double contentSpacer = 20.h;
    return Stack(
      children: [
        Scaffold(
          appBar: SimpleAppbar(
            title:
                widget.isFutureProduct == true
                    ? "Ajout future produit"
                    : widget.productToEdit != null
                    ? "Modifier produit"
                    : "Ajout produit",
            onBack: () {
              context.go("/nav-bar/:0");
            },
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(StylesConstants.spacerContent),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.productToEdit == null) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleWithExplaination(
                              title: "Image du produit",
                              explaination:
                                  "Importer un image qui represente votre produit",
                            ),
                            SizedBox(height: contentSpacer),
                          ],
                        ),
                      ],

                      ImagePickerDisplay(
                        onPickImage: () async {
                          final image = await _mediaService.pickImage(
                            fromGallery: true,
                          );
                          setState(() {
                            _productImage = image;
                          });
                        },
                        onRemoveImage: () {
                          setState(() {
                            _productImage = null;
                          });
                        },
                        imageFile: _productImage,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SeparatorBackground(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleWithExplaination(
                              title: "Informations du produit",
                              explaination:
                                  "Données les informations precise du produit",
                            ),

                            SizedBox(height: contentSpacer),
                            MediumTitleWithDegree(
                              showDegree: true,
                              degree: 1,
                              title: "Nom Produit",
                            ),
                            SimpleInput(
                              textHint: "ex: pince flexible",
                              iconData: HugeIcons.strokeRoundedId,
                              textEditControlleur: nomProduitInput,
                              maxLines: 1,
                            ),
                            ShowInputError(message: errorName),
                            SizedBox(height: contentSpacer),
                            MediumTitleWithDegree(
                              showDegree: true,
                              degree: 2,
                              title: "Code produit",
                            ),
                            SimpleInput(
                              textHint: "ex: pinceF02i",
                              iconData: HugeIcons.strokeRoundedBarCode01,
                              textEditControlleur: codeProduitInput,
                              maxLines: 1,
                            ),

                            SizedBox(height: contentSpacer),
                            NumberInput(
                              value: qteProduit,
                              title: "Quantité(s) produit *",
                              onValueChanged: (qte) {
                                setState(() {
                                  qteProduit = qte;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  SeparatorBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWithExplaination(
                          title: "Détails sur les prix",
                          explaination:
                              "Informer le system des détails sur le prix produit",
                        ),
                        SizedBox(height: contentSpacer),
                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 1,
                          title: "Prix d'achat unitaire (Ar)",
                        ),
                        SimpleInput(
                          textHint: "ex: 3000",
                          iconData: HugeIcons.strokeRoundedMoney01,
                          textEditControlleur: purchasePriceInput,
                          maxLines: 1,
                        ),
                        SizedBox(height: contentSpacer),
                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 1,
                          title: "Prix de vente unitaire (Ar)",
                        ),
                        SimpleInput(
                          textHint: "ex: 6000",
                          iconData: HugeIcons.strokeRoundedMoneyBag01,
                          textEditControlleur: sellingPriceInput,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),

                  SeparatorBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWithExplaination(
                          title: "Détails du produit",
                          explaination:
                              "Prenez le temps d'ajouter les détails du produit",
                        ),
                        SizedBox(height: contentSpacer),
                        MediumTitleWithDegree(
                          showDegree: true,
                          degree: 2,
                          title: "Type de produit",
                        ),
                        CustomDropdown(
                          iconData: HugeIcons.strokeRoundedCheckList,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                          items: typeOfProductList,
                          textHint: "Selectioner un type",
                          value: selectedType,
                        ),
                        SizedBox(height: contentSpacer),
                        MediumTitleWithDegree(
                          showDegree: true,
                          title: "Variante(s)",
                          degree: 2,
                        ),
                        ItemManagerSection(
                          initialVariants: widget.productToEdit?.variant ?? [],
                          onChanged: (variants, images) {
                            setState(() {
                              _variants = variants;
                              _variantImages = images;
                            });
                          },
                        ),
                        SizedBox(height: contentSpacer + 10),
                        MediumTitleWithDegree(
                          showDegree: true,
                          title: "Déscription(s)",
                          degree: 2,
                        ),
                        SimpleInput(
                          textHint: "Décriver votre produit",
                          iconData: HugeIcons.strokeRoundedMenu06,
                          textEditControlleur: descProduitInput,
                          maxLines: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 80,
            color: Colors.white,
            child: BottomContainerButton(
              leftContentChild: CustomToggle(
                onChanged: (value) {
                  setState(() {
                    isFutureProduct = value;
                  });
                  print(isFutureProduct);
                },
                isFuture: widget.isFutureProduct,
                desableOnDefaultValue:
                    widget.isFutureProduct == true ? true : false,
              ),
              nextBtnText:
                  widget.productToEdit != null ? "Modifier" : "Ajouter",
              onBack: () {
                context.go("/nav-bar/:0");
              },
              onValidate: () {
                if (_validateFields()) {
                  setState(() {
                    showPopUp = true;
                  });
                } else {}
              },
            ),
          ),
        ),
        if (productState.isLoading) Loading(),
        if (showPopUp)
          TransparentBackgroundPopUp(
            widget: ConfirmationDialogue(
              backGroundColor: Theme.of(context).colorScheme.surface,

              btnColor: null,
              isActionDangerous: false,
              title:
                  widget.productToEdit != null
                      ? "Voulez vous Modifier ce produit ${nomProduitInput.text.trim()}"
                      : "Voulez vous Ajouter le produit ${nomProduitInput.text.trim()}",
              value: "",
              icon: HugeIcons.strokeRoundedStoreAdd01,
              isloading: productState.isLoading,
              onTapLeftBtn: () {
                setState(() {
                  showPopUp = false;
                });
              },
              onTapRightBtn: () async {
                setState(() {
                  showPopUp = false;
                });

                if (widget.productToEdit != null) {
                  final updateMe = widget.productToEdit!.copyWith(
                    name: nomProduitInput.text.trim(),
                    quantity: qteProduit,
                    description: descProduitInput.text,
                    variant: _variants,
                    eId: codeProduitInput.text,
                    type: selectedType,
                    futureProduct: isFutureProduct,
                    purchasePrice: double.tryParse(purchasePriceInput.text),
                    sellingPrice: double.tryParse(sellingPriceInput.text),
                  );
                  await productAction.updateProduct(updateMe);
                } else {
                  final addMe = ProductEntities(
                    name: nomProduitInput.text.trim(),
                    quantity: qteProduit,
                    description: descProduitInput.text,
                    variant: _variants,
                    eId: codeProduitInput.text,
                    type: selectedType,
                    futureProduct: isFutureProduct,
                    purchasePrice: double.tryParse(purchasePriceInput.text),
                    sellingPrice: double.tryParse(sellingPriceInput.text),
                  );
                  await productAction.addProduct(
                    addMe,
                    _productImage,
                    _variantImages,
                    authState.user!.id!,
                  );
                }
                // refresh list ----------
                await productAction.researchProduct(null);

                // vider les input apres ajout -----------
                _productImage = null;
                codeProduitInput.text = "";
                nomProduitInput.text = "";
                descProduitInput.text = "";
                qteProduit = 0;
                selectedType = null;
                _variants = [];
                purchasePriceInput.text = "";
                sellingPriceInput.text = "";
              },
            ),
          ),
      ],
    );
  }
}
