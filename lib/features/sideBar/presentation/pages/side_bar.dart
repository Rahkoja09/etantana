import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/app/session/session_controller.dart';
import 'package:e_tantana/features/sideBar/presentation/widgets/logout_dialogue.dart';
import 'package:e_tantana/shared/widget/banner/custom_simple_banner.dart';
import 'package:e_tantana/shared/widget/input/list_item_action.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:e_tantana/shared/widget/popup/show_custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SideBar extends ConsumerWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final authAction = ref.read(authControllerProvider.notifier);
    final user = authState.user;
    final sessionStates = ref.watch(sessionProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: authState.isLoading,
      effect: LoadingEffect.getCommonEffect(context),
      justifyMultiLineText: true,
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(StylesConstants.spacerContent),
              color: colorScheme.surfaceContainerLowest,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 40.h,
                              width: 40.w,
                              child: ImageViewer(
                                imageFileOrLink:
                                    sessionStates.hasShop
                                        ? sessionStates.activeShop?.shopLogo
                                        : authState.user?.photoUrl ??
                                            AppConst.defaultImage,
                                borderRadius: 100,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sessionStates.hasShop
                                      ? sessionStates.activeShop!.shopName!
                                      : user?.email?.split('@')[0] ??
                                          "Utilisateur",
                                  style: TextStyles.bodyText(
                                    context: context,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user?.email ?? "email@example.com",
                                  style: TextStyles.bodySmall(
                                    context: context,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- PARTIE 2 : LISTE ---
            Expanded(
              child: Container(
                color: colorScheme.surfaceContainer,
                child: Column(
                  children: [
                    ListItemAction(
                      icon: Icons.person_outline,
                      label: "Profil",
                      onTap: () => context.push("/user/profil"),
                      noIcon: true,
                    ),
                    ListItemAction(
                      icon: Icons.gavel_outlined,
                      label: "Politiques",
                      onTap: () => context.push("/policies"),
                      noIcon: true,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomSimpleBanner(
                        title: "Smart Inventory Predictor",
                        subtitle:
                            "Anticipez les ruptures avant qu'elles arrivent.",
                        onTap: () => context.push("/stock-prediction"),
                      ),
                    ),
                    const Divider(),
                    ListItemAction(
                      icon: Icons.logout_rounded,
                      label: "Deconnexion",
                      color: Colors.redAccent,
                      onTap: () {
                        showCustomPopup(
                          context: context,
                          title: "Deconnexion",
                          isError: true,
                          dismissible: true,
                          isActionDangerous: true,
                          leftButtonTitle: "non",
                          isLoading: authState.isLoading,
                          onTapRightBtn: () async {
                            await authAction.logout();
                            Scaffold.of(context).closeEndDrawer();
                            context.go("/sign-in");
                          },
                          child: LogoutDialogue(),

                          rightButtonTitle: "oui",
                          description:
                              'vous êtes sur le point d\'abondonner cette session.',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
