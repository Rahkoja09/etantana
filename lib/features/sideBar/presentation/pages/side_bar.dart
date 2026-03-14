// lib/features/nav_bar/presentation/widgets/sidebar.dart
import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/auth/presentation/pages/sign_in.dart';
import 'package:e_tantana/features/policies/presentation/pages/policies_page.dart';
import 'package:e_tantana/features/shop/presentation/controller/shop_controller.dart';
import 'package:e_tantana/features/shop/presentation/pages/shop_page.dart';
import 'package:e_tantana/features/sideBar/presentation/widgets/logout_dialogue.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/features/stockPrediction/presentation/pages/stock_prediction_pages.dart';
import 'package:e_tantana/features/stockPrediction/presentation/widgets/stock_prediction_banner_card.dart';
import 'package:e_tantana/features/user/presentation/pages/profil_page.dart';
import 'package:e_tantana/shared/widget/banner/custom_simple_banner.dart';
import 'package:e_tantana/shared/widget/iconCard/action_icon_box.dart';
import 'package:e_tantana/shared/widget/input/list_item_action.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/show_custom_popup.dart';
import 'package:e_tantana/shared/widget/sizeBar/custom_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SideBar extends ConsumerWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final shopState = ref.watch(shopControllerProvider);
    final authAction = ref.read(authControllerProvider.notifier);
    final stockPredictionState = ref.watch(stockPredictionControllerProvider);
    final user = authState.user;
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
                        CustomAvatar(
                          imageUrlOrAssets:
                              authState.user?.photoUrl ?? AppConst.defaultImage,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.email?.split('@')[0] ?? "Utilisateur",
                              style: TextStyles.bodyText(
                                context: context,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.email ?? "email@example.com",
                              style: TextStyles.bodySmall(
                                context: context,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionIconBox(
                          icon: Icons.notifications_none,
                          onTap: () {},
                        ),
                        ActionIconBox(
                          icon: HugeIcons.strokeRoundedAiContentGenerator01,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const StockPredictionPage(),
                              ),
                            );
                          },
                        ),
                        ActionIconBox(icon: Icons.qr_code_2, onTap: () {}),
                        ActionIconBox(icon: Icons.share_outlined, onTap: () {}),
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProfilPage()),
                        );
                      },
                      noIcon: true,
                    ),
                    ListItemAction(
                      icon: Icons.gavel_outlined,
                      label: "Politiques",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PoliciesPage(),
                          ),
                        );
                      },
                      noIcon: true,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomSimpleBanner(
                        title: "Smart Inventory Predictor",
                        subtitle:
                            "Anticipez les ruptures avant qu'elles arrivent.",
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StockPredictionPage(),
                              ),
                            ),
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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const SignIn()),
                            );
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
