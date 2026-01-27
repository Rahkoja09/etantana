import 'dart:io';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/features/nav_bar/presentation/nav_bar.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/input/switch_button.dart';
import 'package:e_tantana/shared/widget/popup/confirmation_dialogue.dart';
import 'package:e_tantana/shared/widget/popup/custom_dialog.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:e_tantana/shared/widget/text/horizontal_divider.dart';
import 'package:e_tantana/shared/widget/mediaView/image_picker_display.dart';
import 'package:e_tantana/shared/widget/input/custom_drop_down.dart';
import 'package:e_tantana/shared/widget/input/item_manager_section.dart';
import 'package:e_tantana/shared/widget/loading/loading.dart';
import 'package:e_tantana/shared/widget/text/medium_title_with_degree.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/popup/transparent_background_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  String variantsForServer = "";
  bool? isFutureProduct;

  @override
  void initState() {
    super.initState();
    isFutureProduct = widget.isFutureProduct;
    if (widget.productToEdit != null) {
      final p = widget.productToEdit!;
      nomProduitInput.text = p.name ?? "";
      codeProduitInput.text = p.eId ?? "";
      descProduitInput.text = p.description ?? "";
      purchasePriceInput.text = p.purchasePrice?.toString() ?? "";
      sellingPriceInput.text = p.sellingPrice?.toString() ?? "";
      qteProduit = p.quantity ?? 0;
      selectedType = p.type;
      isFutureProduct = p.futureProduct ?? false;
      _productImage = p.images;
      variantsForServer = p.details!;
    }
  }

  final _mediaService = sl<MediaServices>();
  bool showPopUp = false;

  List<String> typeOfProductList = [
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
    final width =
        MediaQuery.of(context).size.width - (StylesConstants.spacerContent * 2);

    final productState = ref.watch(productControllerProvider);
    final productAction = ref.read(productControllerProvider.notifier);

    ref.listen<ProductState>(productControllerProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        showDialog(
          context: context,
          builder:
              (context) => ErrorDialog(
                title: "Erreur d'ajout de produit\nRéessayer plus tard.",
                message: next.errorMessage!,
              ),
        );
      }
      if (next.product != null && next.isLoading == false) {
        if (widget.productToEdit != null) {
          showToast(
            context,
            title: 'Modification produit réussi.',
            isError: false,
            description:
                "${nomProduitInput.text.trim()} est modifié avec succès!",
          );
        } else {
          showToast(
            context,
            title: 'Ajout produit réussi.',
            isError: false,
            description: "${nomProduitInput.text.trim()} ajouté avec succès!",
          );
        }
      }
    });
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => NavBar(selectedIndex: 0)),
              );
            },
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(StylesConstants.spacerContent),
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MediumTitleWithDegree(
                        showDegree: false,
                        title: "PHOTO DU PRODUIT",
                      ),
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
                  SizedBox(height: 30.h),

                  SwitchButton(
                    isEnabled: widget.isFutureProduct == true ? false : true,
                    degree: 1,
                    showDegree: true,
                    title: "Produit encore en transite",
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        isFutureProduct = value;
                      });
                    },
                    value:
                        widget.isFutureProduct == true
                            ? widget.isFutureProduct
                            : isFutureProduct!,
                  ),
                  SizedBox(height: 30.h),
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 2,
                    title: "Code produit",
                  ),
                  SimpleInput(
                    textHint: "ex: pinceF02i",
                    iconData: HugeIcons.strokeRoundedFingerPrint,
                    textEditControlleur: codeProduitInput,
                    maxLines: 1,
                  ),
                  SizedBox(height: 30.h),
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

                  SizedBox(height: 30.h),
                  NumberInput(
                    value: qteProduit,
                    title: "Quantité(s) produit *",
                    onValueChanged: (qte) {
                      setState(() {
                        qteProduit = qte;
                      });
                    },
                  ),
                  SizedBox(height: 30.h),

                  HorizontalDivider(
                    width: width,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 10.h),

                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Prix d'achat (Ar)",
                  ),
                  SimpleInput(
                    textHint: "ex: 3000",
                    iconData: HugeIcons.strokeRoundedMoney01,
                    textEditControlleur: purchasePriceInput,
                    maxLines: 1,
                  ),
                  SizedBox(height: 30.h),
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Prix de vente (Ar)",
                  ),
                  SimpleInput(
                    textHint: "ex: 6000",
                    iconData: HugeIcons.strokeRoundedMoneyBag01,
                    textEditControlleur: sellingPriceInput,
                    maxLines: 1,
                  ),
                  SizedBox(height: 10.h),
                  ShowInputError(message: errorQuantity),
                  HorizontalDivider(
                    width: width,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 30.h),
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
                  SizedBox(height: 30.h),
                  MediumTitleWithDegree(
                    showDegree: true,
                    title: "Détail(s)",
                    degree: 2,
                  ),
                  ItemManagerSection(
                    varianteInString: variantsForServer,
                    onChanged: (variante) {
                      setState(() {
                        variantsForServer = variante;
                      });
                    },
                  ),
                  SizedBox(height: 30.h),
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
                  SizedBox(height: 30.h),
                  BottomContainerButton(
                    prevBtnText: "Annuler",
                    nextBtnText:
                        widget.productToEdit != null ? "Modifier" : "Ajouter",
                    onBack: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => NavBar(selectedIndex: 0),
                        ),
                      );
                    },
                    onValidate: () {
                      if (_validateFields()) {
                        setState(() {
                          showPopUp = true;
                        });
                      } else {}
                    },
                  ),
                ],
              ),
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
                    details: variantsForServer,
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
                    details: variantsForServer,
                    eId: codeProduitInput.text,
                    type: selectedType,
                    futureProduct: isFutureProduct,
                    purchasePrice: double.tryParse(purchasePriceInput.text),
                    sellingPrice: double.tryParse(sellingPriceInput.text),
                  );
                  await productAction.addProduct(addMe, _productImage);
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
                variantsForServer = "";
                purchasePriceInput.text = "";
                sellingPriceInput.text = "";
              },
            ),
          ),
      ],
    );
  }
}
