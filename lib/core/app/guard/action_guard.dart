import 'package:e_tantana/core/app/session/session_controller.dart';
import 'package:e_tantana/features/shop/presentation/pages/create_shop_page.dart';
import 'package:e_tantana/features/user/presentation/pages/create_user_profil.dart';
import 'package:e_tantana/shared/widget/popup/guard_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionGuard {
  static bool check({
    required BuildContext context,
    required WidgetRef ref,
    bool requireUser = false,
    bool requireShop = false,
    bool requiredPremium = false,
    VoidCallback? onAllowed,
  }) {
    final session = ref.read(sessionProvider);
    final user = ref.read(sessionProvider).user;

    if (requiredPremium && user?.userPlan == "free") {}

    if (requireUser && !session.hasUser) {
      GuardPopup.show(
        context,
        icon: Icons.person_outline_rounded,
        title: "Profil requis",
        message: "Créez votre profil pour accéder à cette fonctionnalité.",
        actionLabel: "Créer mon profil",
        onAction:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateUserProfil()),
            ),
      );
      return false;
    }

    if (requireShop && !session.hasShop) {
      GuardPopup.show(
        context,
        icon: Icons.store_outlined,
        title: "Boutique requise",
        message: "Créez votre boutique avant d'ajouter des produits.",
        actionLabel: "Créer ma boutique",
        onAction:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateShopPage()),
            ),
      );
      return false;
    }

    onAllowed?.call();
    return true;
  }
}
