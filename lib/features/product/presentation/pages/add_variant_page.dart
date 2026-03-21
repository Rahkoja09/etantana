import 'dart:io';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/input/custom_dropdown_with_input.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/mediaView/image_picker_display.dart';
import 'package:e_tantana/shared/widget/others/separator_background.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:e_tantana/shared/widget/title/title_with_explaination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

// ── Résultat retourné à la page parente ──────────────────────
class AddVariantResult {
  final Map<String, dynamic> variant;
  final File? image;

  const AddVariantResult({required this.variant, this.image});
}

class AddVariantPage extends StatefulWidget {
  /// Variant existant — pour le mode édition
  final Map<String, dynamic>? existingVariant;
  final File? existingImage;

  const AddVariantPage({super.key, this.existingVariant, this.existingImage});

  @override
  State<AddVariantPage> createState() => _AddVariantPageState();
}

class _AddVariantPageState extends State<AddVariantPage> {
  // ── Controllers ──────────────────────────────────────────
  final _nameCtrl = TextEditingController();
  final _propertyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String? _variantType;
  String? _propertyType;
  int _quantity = 1;
  File? _image;
  dynamic _existingImageUrl;

  final _mediaService = sl<MediaServices>();

  // ── Suggestions fixes + extensibles ──────────────────────
  static const List<String> _variantTypeSuggestions = [
    "Couleur",
    "Taille",
    "Personnage",
    "Matière",
    "Style",
    "Modèle",
    "Saveur",
  ];

  static const List<String> _propertyTypeSuggestions = [
    "cm",
    "mm",
    "kg",
    "g",
    "L",
    "ml",
    "Pointure",
    "Série",
  ];

  bool get _isEdit => widget.existingVariant != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final v = widget.existingVariant!;
      _nameCtrl.text = v['name']?.toString() ?? '';
      _variantType = v['variant_type']?.toString();
      _propertyCtrl.text = v['property']?.toString() ?? '';
      _propertyType = v['property_type']?.toString();
      _priceCtrl.text = v['price'] != null ? v['price'].toString() : '';
      _quantity = v['quantity'] as int? ?? 1;
      _existingImageUrl =
          v['image']?.toString().isNotEmpty == true ? v['image'] : null;
      _image = widget.existingImage;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _propertyCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  // ── Validation ────────────────────────────────────────────
  String? _errorName;

  bool _validate() {
    setState(() {
      _errorName =
          _nameCtrl.text.trim().isEmpty ? "Le nom du variant est requis" : null;
    });
    return _errorName == null;
  }

  // ── Valider et retourner ──────────────────────────────────
  void _submit() {
    if (!_validate()) return;

    final variant = {
      "name": _nameCtrl.text.trim(),
      "variant_type": _variantType ?? "-",
      "property":
          _propertyCtrl.text.trim().isEmpty ? "-" : _propertyCtrl.text.trim(),
      "property_type": _propertyType ?? "-",
      "quantity": _quantity,
      "price": double.tryParse(_priceCtrl.text),
      "image": _image == null ? (_existingImageUrl ?? "") : "",
    };

    context.pop(AddVariantResult(variant: variant, image: _image));
  }

  @override
  Widget build(BuildContext context) {
    final contentSpacer = 16.h;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: SimpleAppbar(
        title: _isEdit ? "Modifier le variant" : "Ajouter un variant",
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(StylesConstants.spacerContent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image du variant ─────────────────────────
            SeparatorBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWithExplaination(
                    title: "Image du variant",
                    explaination: "Optionnel — image spécifique à ce variant",
                  ),
                  SizedBox(height: contentSpacer),
                  ImagePickerDisplay(
                    imageFile: _image ?? _existingImageUrl,
                    onPickImage: () async {
                      final img = await _mediaService.pickImage(
                        fromGallery: true,
                      );
                      if (img != null) setState(() => _image = img);
                    },
                    onRemoveImage:
                        () => setState(() {
                          _image = null;
                          _existingImageUrl = null;
                        }),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // ── Nom + Type de variant ─────────────────────
            SeparatorBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWithExplaination(
                    title: "Identification du variant",
                    explaination: "Donnez un nom et un type à ce variant",
                  ),
                  SizedBox(height: contentSpacer),

                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Nom du variant *",
                  ),
                  SimpleInput(
                    textHint: "ex: Rouge, Naruto, Pliable",
                    iconData: HugeIcons.strokeRoundedTag01,
                    textEditControlleur: _nameCtrl,
                    maxLines: 1,
                  ),
                  if (_errorName != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      _errorName!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],

                  SizedBox(height: contentSpacer),

                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 2,
                    title: "Type de variant",
                  ),
                  CustomDropdownWithInput(
                    textHint: "ex: Couleur, Personnage",
                    iconData: HugeIcons.strokeRoundedColors,
                    suggestions: _variantTypeSuggestions,
                    value: _variantType,
                    onChanged: (val) => setState(() => _variantType = val),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // ── Propriété ─────────────────────────────────
            SeparatorBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWithExplaination(
                    title: "Propriété du variant",
                    explaination:
                        "Optionnel — détail supplémentaire (taille, série...)",
                  ),
                  SizedBox(height: contentSpacer),

                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Valeur de la propriété",
                  ),
                  SimpleInput(
                    textHint: "ex: 16cm, Gojo, Noir",
                    iconData: HugeIcons.strokeRoundedInformationCircle,
                    textEditControlleur: _propertyCtrl,
                    maxLines: 1,
                  ),

                  SizedBox(height: contentSpacer),

                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 2,
                    title: "Type de propriété",
                  ),
                  CustomDropdownWithInput(
                    textHint: "ex: Taille, Personnage, Couleur",
                    iconData: HugeIcons.strokeRoundedPackageDimensions02,
                    suggestions: _propertyTypeSuggestions,
                    value: _propertyType,
                    onChanged: (val) => setState(() => _propertyType = val),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // ── Quantité + Prix ───────────────────────────
            SeparatorBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWithExplaination(
                    title: "Stock et prix",
                    explaination:
                        "Quantité disponible et prix spécifique à ce variant",
                  ),
                  SizedBox(height: contentSpacer),

                  NumberInput(
                    title: "Quantité disponible *",
                    value: _quantity,
                    onValueChanged: (val) => setState(() => _quantity = val),
                  ),

                  SizedBox(height: contentSpacer),

                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 2,
                    title: "Prix spécifique (Ar)",
                  ),
                  SimpleInput(
                    textHint: "Laisser vide = prix du produit parent",
                    iconData: HugeIcons.strokeRoundedMoney01,
                    textEditControlleur: _priceCtrl,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),
      bottomNavigationBar: BottomContainerButton(
        nextBtnText: _isEdit ? "Modifier" : "Ajouter",
        onBack: () => context.pop(),
        onValidate: _submit,
      ),
    );
  }
}
