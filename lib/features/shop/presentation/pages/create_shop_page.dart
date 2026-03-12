import 'dart:io';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:e_tantana/features/shop/presentation/controller/shop_controller.dart';
import 'package:e_tantana/features/user/presentation/widgets/profile_image_uploader.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/loading/loading.dart';
import 'package:e_tantana/shared/widget/popup/transparent_background_pop_up.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class CreateShopPage extends ConsumerStatefulWidget {
  const CreateShopPage({super.key});

  @override
  ConsumerState<CreateShopPage> createState() => _CreateShopPageState();
}

class _CreateShopPageState extends ConsumerState<CreateShopPage> {
  final _mediaService = sl<MediaServices>();
  final _formKey = GlobalKey<FormState>();

  File? _shopLogo;

  final _shopNameController = TextEditingController();
  final _sloganController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _socialLinkController = TextEditingController();
  final _socialContactController = TextEditingController();

  bool _logoError = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    _sloganController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _socialLinkController.dispose();
    _socialContactController.dispose();
    super.dispose();
  }

  bool _validate() {
    final formValid = _formKey.currentState?.validate() ?? false;
    final hasLogo = _shopLogo != null;
    setState(() => _logoError = !hasLogo);
    return formValid && hasLogo;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    final shop = ShopEntity(
      shopName: _shopNameController.text.trim(),
      slogan:
          _sloganController.text.trim().isEmpty
              ? null
              : _sloganController.text.trim(),
      description:
          _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
      phoneContact:
          _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
      socialLink:
          _socialLinkController.text.trim().isEmpty
              ? null
              : _socialLinkController.text.trim(),
      socialContact:
          _socialContactController.text.trim().isEmpty
              ? null
              : _socialContactController.text.trim(),
    );

    await ref
        .read(shopControllerProvider.notifier)
        .createShop(
          shop,
          _shopLogo!,
          ref.watch(authControllerProvider).user?.id,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: SimpleAppbar(
            onBack: () => Navigator.pop(context),
            title: "Créer ma boutique",
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(StylesConstants.spacerContent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Logo ----
                  ProfileImageUploader(
                    onDeleteImage: () => setState(() => _shopLogo = null),
                    onPickImage: () async {
                      final image = await _mediaService.pickImage(
                        fromGallery: true,
                      );
                      setState(() {
                        _shopLogo = image;
                        if (image != null) _logoError = false;
                      });
                    },
                    imageFile: _shopLogo,
                    currentImageUrl: "",
                    isLoading: false,
                  ),
                  SizedBox(height: 8.h),

                  Center(
                    child: MediumTitleWithDegree(
                      showDegree: false,
                      degree: 1,
                      title: "Logo de la boutique",
                    ),
                  ),

                  // Erreur logo
                  if (_logoError) ...[
                    SizedBox(height: 4.h),
                    Center(
                      child: Text(
                        "Veuillez ajouter un logo",
                        style: TextStyles.bodySmall(
                          context: context,
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 32.h),

                  // ---- Informations principales ----
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Informations principales",
                  ),

                  _RequiredInput(
                    controller: _shopNameController,
                    hint: "Nom de la boutique",
                    icon: HugeIcons.strokeRoundedStore01,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Le nom est obligatoire";
                      }
                      if (v.trim().length < 3) {
                        return "Minimum 3 caractères";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),

                  _RequiredInput(
                    controller: _sloganController,
                    hint: "Slogan (ex: La qualité avant tout)",
                    icon: HugeIcons.strokeRoundedQuoteDown,
                    maxLines: 1,
                  ),
                  SizedBox(height: 12.h),

                  _RequiredInput(
                    controller: _descriptionController,
                    hint: "Description de la boutique",
                    icon: HugeIcons.strokeRoundedNoteEdit,
                    maxLines: 4,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "La description est obligatoire";
                      }
                      if (v.trim().length < 10) {
                        return "Minimum 10 caractères";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 32.h),

                  // ---- Contact ----
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 2,
                    title: "Contact",
                  ),

                  _RequiredInput(
                    controller: _phoneController,
                    hint: "Numéro de téléphone",
                    icon: HugeIcons.strokeRoundedCall,
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Le téléphone est obligatoire";
                      }
                      if (v.trim().length < 8) {
                        return "Numéro invalide";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),

                  _RequiredInput(
                    controller: _socialContactController,
                    hint: "Contact réseau social (ex: @ma_boutique)",
                    icon: HugeIcons.strokeRoundedFacebook01,
                    maxLines: 1,
                  ),

                  SizedBox(height: 32.h),

                  // ---- Présence en ligne ----
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 3,
                    title: "Présence en ligne",
                  ),

                  _RequiredInput(
                    controller: _socialLinkController,
                    hint: "Lien réseau social ou site web",
                    icon: HugeIcons.strokeRoundedLink01,
                    keyboardType: TextInputType.url,
                  ),

                  SizedBox(height: 32.h),

                  // Note champs optionnels
                  _buildOptionalNote(context),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomContainerButton(
            onBack: () => Navigator.pop(context),
            onValidate: _submit,
            nextBtnText: "Créer la boutique",
          ),
        ),

        if (shopState.isLoading)
          Positioned.fill(
            child: TransparentBackgroundPopUp(
              widget: const Center(child: Loading()),
            ),
          ),
      ],
    );
  }

  Widget _buildOptionalNote(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14.sp,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.35),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "Les champs slogan, contact social et lien sont optionnels.",
              style: TextStyles.bodySmall(
                context: context,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Widget input interne ----

class _RequiredInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _RequiredInput({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleInput(
      textHint: hint,
      iconData: icon,
      textEditControlleur: controller,
      maxLines: maxLines,
    );
  }
}
