import 'package:e_tantana/core/app/appShell/app_shell.dart';
import 'package:e_tantana/features/auth/presentation/pages/confirme_otp.dart';
import 'package:e_tantana/features/auth/presentation/pages/forgot_password.dart';
import 'package:e_tantana/features/auth/presentation/pages/onboarding_page.dart';
import 'package:e_tantana/features/auth/presentation/pages/reset_password.dart';
import 'package:e_tantana/features/auth/presentation/pages/sign_in.dart';
import 'package:e_tantana/features/auth/presentation/pages/sign_up.dart';
import 'package:e_tantana/features/feedback/presentation/pages/feedback_page.dart';
import 'package:e_tantana/features/nav_bar/presentation/nav_bar.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/presentation/pages/add_order.dart';
import 'package:e_tantana/features/order/presentation/pages/order.dart';
import 'package:e_tantana/features/policies/presentation/models/policy_content.dart';
import 'package:e_tantana/features/policies/presentation/pages/policies_page.dart';
import 'package:e_tantana/features/policies/presentation/widgets/policy_detail_page.dart';
import 'package:e_tantana/features/printer/presentation/pages/printer_view.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/pages/add_product.dart';
import 'package:e_tantana/features/product/presentation/pages/add_variant_page.dart';
import 'package:e_tantana/features/product/presentation/pages/create_pack.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:e_tantana/features/shop/presentation/pages/create_shop_page.dart';
import 'package:e_tantana/features/shop/presentation/pages/shop_page.dart';
import 'package:e_tantana/features/stockPrediction/presentation/pages/stock_prediction_pages.dart';
import 'package:e_tantana/features/user/presentation/pages/create_user_profil.dart';
import 'package:e_tantana/features/user/presentation/pages/profil_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const AppShell(),
        routes: [
          // auth -----------
          GoRoute(path: "sign-in", builder: (_, __) => const SignIn()),
          GoRoute(path: "sign-up", builder: (_, __) => const SignUp()),
          GoRoute(
            path: "forgot-password",
            builder: (_, __) => const ForgotPassword(),
          ),
          GoRoute(path: "confirm-otp", builder: (_, __) => const ConfirmeOtp()),
          GoRoute(
            path: "reset-password",
            builder: (_, __) => const ResetPassword(),
          ),
          GoRoute(
            path: "onboarding-page",
            builder: (_, __) => const OnboardingPage(),
          ),

          //navbar -------
          GoRoute(
            path: "nav-bar/:selectedPageIndex",
            builder: (_, state) {
              final index = int.parse(
                state.pathParameters['selectedPageIndex']!,
              );
              return NavBar(selectedIndex: index);
            },
          ),

          // profil ---------------
          GoRoute(path: "user/profil", builder: (_, __) => const ProfilPage()),
          GoRoute(
            path: 'user/profil/create',
            builder: (_, __) => const CreateUserProfil(),
          ),

          // order ----
          GoRoute(path: "order/view", builder: (_, __) => const Order()),
          GoRoute(path: "order/add", builder: (_, __) => AddOrder()),

          // product ----
          GoRoute(
            path: 'product/add/:isFuture',
            builder: (_, state) {
              final isFuture = state.pathParameters['isFuture'] == 'true';
              final productToEdit = state.extra;

              return AddProduct(
                isFutureProduct: isFuture,
                productToEdit:
                    productToEdit != null
                        ? productToEdit as ProductEntities
                        : null,
              );
            },
          ),
          GoRoute(
            path: 'product/add-variant',
            builder: (_, state) {
              final args = state.extra as Map<String, dynamic>?;
              return AddVariantPage(
                existingVariant: args?['variant'],
                existingImage: args?['image'],
              );
            },
          ),
          GoRoute(
            path: 'product/create-pack',
            builder: (_, state) => const CreatePack(),
          ),

          // shope -----------
          GoRoute(
            path: "shop/view",
            builder: (context, state) {
              final shope = state.extra as ShopEntity;
              return ShopPage(shop: shope);
            },
          ),
          GoRoute(
            path: 'shop/create',
            builder: (_, __) => const CreateShopPage(),
          ),

          // printer -----
          GoRoute(
            path: 'printer',
            builder: (_, state) {
              final order = state.extra as OrderEntities;
              return PrinterView(order: order);
            },
          ),

          // policies ------
          GoRoute(path: 'policies', builder: (_, __) => const PoliciesPage()),
          GoRoute(
            path: 'policies/details',
            builder: (context, state) {
              final details = state.extra as PolicyType;
              return PolicyDetailPage(policyType: details);
            },
          ),

          // stock prediction ----------
          GoRoute(
            path: 'stock-prediction',
            builder: (_, __) => const StockPredictionPage(),
          ),

          // feedback ------------
          GoRoute(path: 'feedback', builder: (_, __) => const FeedbackPage()),
        ],
      ),
    ],
  );
});
