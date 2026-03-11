import 'dart:io';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';
import 'package:e_tantana/features/user/presentation/controller/user_controller.dart';
import 'package:e_tantana/features/user/presentation/widgets/profile_image_uploader.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/input/custom_drop_down.dart';
import 'package:e_tantana/shared/widget/input/date_input.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/loading/loading.dart';
import 'package:e_tantana/shared/widget/popup/transparent_background_pop_up.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class CreateUserProfil extends ConsumerStatefulWidget {
  const CreateUserProfil({super.key});

  @override
  ConsumerState<CreateUserProfil> createState() => _CreateUserProfilState();
}

class _CreateUserProfilState extends ConsumerState<CreateUserProfil> {
  final _mediaService = sl<MediaServices>();
  File? profilImage;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  DateTime? birthDate;
  String? JobTitle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authControllerProvider).user;
      if (user != null && user.email != null) {
        emailController.text = user.email!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final userState = ref.watch(userControllerProvider);
    final userAction = ref.read(userControllerProvider.notifier);
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
                  Center(
                    child: Text(
                      emailController.text,
                      style: TextStyles.bodyMedium(
                        context: context,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Informations personnelles",
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: SimpleInput(
                          textHint: "Nom",
                          iconData: HugeIcons.strokeRoundedIdentityCard,
                          textEditControlleur: nameController,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 15),

                      Expanded(
                        child: SimpleInput(
                          textHint: "Prenom",
                          iconData: HugeIcons.strokeRoundedIdentification,
                          textEditControlleur: lastNameController,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  SimpleInput(
                    textHint: "Pseudo",
                    iconData: HugeIcons.strokeRoundedAnonymous,
                    textEditControlleur: nickNameController,
                    maxLines: 1,
                  ),
                  SizedBox(height: 15),
                  DateInput(
                    iconData: HugeIcons.strokeRoundedCalendarAdd01,
                    textHint: "date de naissance",
                    isRange: false,
                    onDateSelected: (birthDate) {
                      setState(() {
                        birthDate = birthDate;
                      });
                    },
                  ),
                  SizedBox(height: 35),
                  MediumTitleWithDegree(
                    showDegree: true,
                    degree: 1,
                    title: "Informations supplementaire",
                  ),
                  CustomDropdown(
                    items: [
                      "Vendeur",
                      "Livreur",
                      "Propriétaire",
                      "Investisseur",
                      "Agence de Livraison",
                      "Client",
                      "Autres",
                    ],
                    iconData: HugeIcons.strokeRoundedWork,
                    onChanged: (jobValue) {
                      setState(() {
                        JobTitle = jobValue;
                      });
                    },
                    textHint: "je suis ...",
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomContainerButton(
            onBack: () {},
            onValidate: () async {
              final userProfil = UserEntity(
                name: nameController.text.trim(),
                lastName: lastNameController.text.trim(),
                nickName: nickNameController.text.trim(),
                email: emailController.text.trim().toLowerCase(),
                birthDate: birthDate,
                isRegistered: true,
                jobTitle: JobTitle,
                myShops: [],
                userPlan: "free",
              );
              if (profilImage == null) {
                return;
              }
              await userAction.createUser(
                userProfil,
                profilImage!,
                authState.user!.id!,
              );
            },
            nextBtnText: "Créer",
          ),
        ),
        if (userState.isLoading)
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
