import 'dart:io';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/features/user/presentation/widgets/profile_image_uploader.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/loading/loading.dart';
import 'package:e_tantana/shared/widget/popup/transparent_background_pop_up.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class CreateUserProfil extends StatefulWidget {
  const CreateUserProfil({super.key});

  @override
  State<CreateUserProfil> createState() => _CreateUserProfilState();
}

class _CreateUserProfilState extends State<CreateUserProfil> {
  final _mediaService = sl<MediaServices>();
  File? profilImage;
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lockKeyControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: SimpleAppbar(onBack: () {}, title: "Création profil"),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(StylesConstants.spacerContent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileImageUploader(
                    onDeleteImage: () {
                      setState(() {
                        profilImage = null;
                      });
                    },
                    onPickImage: () async {
                      final image = await _mediaService.pickImage(
                        fromGallery: true,
                      );
                      setState(() {
                        profilImage = image;
                      });
                    },
                    imageFile: profilImage,
                    currentImageUrl: "",
                    isLoading: false,
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: MediumTitleWithDegree(
                      showDegree: false,
                      degree: 1,
                      title: "Photo de profil",
                    ),
                  ),
                  SizedBox(height: 25),
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Informations personnelles",
                  ),
                  SimpleInput(
                    textHint: "Adresse Email",
                    iconData: HugeIcons.strokeRoundedMail01,
                    textEditControlleur: emailController,
                    maxLines: 1,
                  ),
                  SizedBox(height: 15),

                  SimpleInput(
                    textHint: "Nom ou pseudo",
                    iconData: HugeIcons.strokeRoundedUser,
                    textEditControlleur: nameController,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomContainerButton(
            onBack: () {},
            onValidate: () {},
            nextBtnText: "Créer",
          ),
        ),
        if (isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: TransparentBackgroundPopUp(widget: Center(child: Loading())),
          ),
      ],
    );
  }
}
