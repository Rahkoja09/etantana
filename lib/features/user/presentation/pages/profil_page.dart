import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/feedback/presentation/pages/feedback_page.dart';
import 'package:e_tantana/features/shop/presentation/controller/shop_controller.dart';
import 'package:e_tantana/features/shop/presentation/pages/create_shop_page.dart';
import 'package:e_tantana/features/shop/presentation/pages/shop_page.dart';
import 'package:e_tantana/features/shop/presentation/widgets/create_shop_card.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';
import 'package:e_tantana/features/user/presentation/controller/user_controller.dart';
import 'package:e_tantana/features/user/presentation/pages/create_user_profil.dart';
import 'package:e_tantana/features/user/presentation/widgets/item_action_list.dart';
import 'package:e_tantana/features/user/presentation/widgets/profil_header_preview.dart';
import 'package:e_tantana/features/user/presentation/widgets/register_placehorlder.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilPage extends ConsumerStatefulWidget {
  const ProfilPage({super.key});

  @override
  ConsumerState<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<ProfilPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(userControllerProvider.notifier)
          .searchUser(
            UserEntity(id: await ref.watch(authControllerProvider).user!.id!),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userStates = ref.watch(userControllerProvider);
    final shopState = ref.watch(shopControllerProvider);
    final authStates = ref.watch(authControllerProvider);

    final userProfile =
        (userStates.users != null && userStates.users!.isNotEmpty)
            ? userStates.users![0]
            : null;

    final bool hasProfile =
        userStates.users != null &&
        userStates.users!.isNotEmpty &&
        userStates.users![0].isRegistered == true;
    final hasShop =
        hasProfile == true && userStates.users![0].myShops!.length > 0;

    final String displayImage =
        userProfile?.profilLink ??
        authStates.user?.photoUrl ??
        AppConst.defaultImage;

    final String displayName =
        userProfile?.name ?? authStates.user!.fullName ?? "Utilisateur";

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
      body: AppRefreshIndicator(
        onRefresh: () async {
          await ref
              .read(userControllerProvider.notifier)
              .searchUser(UserEntity(id: authStates.user!.id));
        },
        child: Skeletonizer(
          effect: LoadingEffect.getCommonEffect(context),
          enabled: userStates.isLoading || authStates.isLoading,
          ignoreContainers: true,
          justifyMultiLineText: true,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(StylesConstants.spacerContent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mon Compte",
                        style: TextStyles.titleSmall(
                          fontSize: 18,
                          context: context,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      InkWell(
                        onTap: () {},
                        child: Icon(
                          HugeIcons.strokeRoundedQrCode,
                          size: 25,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  ProfilHeaderPreview(
                    imageFileOrLink: displayImage,
                    userName: displayName,
                    email: authStates.user!.email!,
                    userPlan: userProfile?.userPlan ?? "Gratuit",
                    jobTitle: userProfile?.jobTitle ?? "Vendeur",
                    shopNumber: userProfile?.myShops?.length ?? 0,
                  ),
                  SizedBox(height: 30),

                  hasProfile
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!hasShop)
                            CreateShopCard(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const CreateShopPage(),
                                  ),
                                );
                              },
                            ),
                          if (hasShop)
                            ItemActionList(
                              leadingIcon: HugeIcons.strokeRoundedStore02,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ShopPage(
                                          shop: (shopState.shops?[0])!,
                                        ),
                                  ),
                                );
                              },
                              title: "Mes Boutiques",
                            ),
                          ItemActionList(
                            leadingIcon: HugeIcons.strokeRoundedMessageEdit02,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const FeedbackPage(),
                                ),
                              );
                            },
                            title: "FeedBack",
                          ),
                        ],
                      )
                      : RegisterPlaceholder(
                        onRegisterTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CreateUserProfil(),
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
