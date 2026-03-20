import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/app/session/session_controller.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/shop/presentation/widgets/create_shop_card.dart';
import 'package:e_tantana/features/user/presentation/widgets/item_action_list.dart';
import 'package:e_tantana/features/user/presentation/widgets/profil_header_preview.dart';
import 'package:e_tantana/features/user/presentation/widgets/register_placehorlder.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/others/separator_background.dart';
import 'package:e_tantana/shared/widget/share/share_qr_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilPage extends ConsumerWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authControllerProvider);

    final session = ref.watch(sessionProvider);
    final user = session.user;
    final activeShop = session.activeShop;

    final bool hasProfile = user?.isRegistered == true;
    final bool hasShop = hasProfile && (user?.myShops?.isNotEmpty ?? false);

    final String displayImage =
        user?.profilLink ?? authState.user?.photoUrl ?? AppConst.defaultImage;
    final String displayName =
        user?.name ?? authState.user?.fullName ?? "Utilisateur";

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
      body: AppRefreshIndicator(
        onRefresh: () async {
          await ref.read(sessionProvider.notifier).refresh();
        },
        child: Skeletonizer(
          effect: LoadingEffect.getCommonEffect(context),
          enabled: session.isInitializing || authState.isLoading,
          ignoreContainers: true,
          justifyMultiLineText: true,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(StylesConstants.spacerContent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header titre + QR ─────────────────────
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
                      if (hasProfile)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => ShareQrPage(
                                      qrData: "etantana://user/${user?.id}",
                                      title: user?.name ?? "",
                                      subtitle: user?.email,
                                      badgeLabel: "Vendeur",
                                      accentColor: colorScheme.primary,
                                      actions: [
                                        ShareQrAction(
                                          icon: HugeIcons.strokeRoundedShare01,
                                          label: "Partager",
                                          onTap: () {},
                                        ),
                                        ShareQrAction(
                                          icon:
                                              HugeIcons.strokeRoundedDownload01,
                                          label: "Sauvegarder",
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                              ),
                            );
                          },
                          child: Icon(
                            HugeIcons.strokeRoundedQrCode,
                            size: 25,
                            color: colorScheme.onSurface,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  if (user != null)
                    ProfilHeaderPreview(
                      imageFileOrLink: displayImage,
                      userName: displayName,
                      email: user.email ?? "",
                      userPlan: user.userPlan ?? "Gratuit",
                      jobTitle: user.jobTitle ?? "Vendeur",
                      shopNumber: user.myShops?.length ?? 0,
                    ),
                  const SizedBox(height: 30),

                  hasProfile
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!hasShop) ...[
                            CreateShopCard(
                              onTap: () {
                                context.push("/shop/create");
                              },
                            ),
                            SizedBox(height: 10.h),
                          ],
                          SeparatorBackground(
                            child: Column(
                              children: [
                                if (hasShop && activeShop != null)
                                  ItemActionList(
                                    leadingIcon: HugeIcons.strokeRoundedStore02,
                                    onTap: () {
                                      context.push("/shop", extra: activeShop);
                                    },
                                    title: "Mes Boutiques",
                                  ),
                                ItemActionList(
                                  leadingIcon:
                                      HugeIcons.strokeRoundedMessageEdit02,
                                  onTap: () {
                                    context.push("/feedback");
                                  },
                                  title: "FeedBack",
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                      : RegisterPlaceholder(
                        onRegisterTap: () {
                          context.push("/profil/create");
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
