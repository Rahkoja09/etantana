import 'package:e_tantana/features/user/presentation/controller/user_controller.dart';
import 'package:e_tantana/features/user/presentation/states/user_states.dart';
import 'package:e_tantana/features/shop/presentation/controller/shop_controller.dart';
import 'package:e_tantana/features/shop/presentation/states/shop_states.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/auth/presentation/states/auth_states.dart';
import 'package:e_tantana/core/error/error_manager.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/mainErrorListener/last_network_time_provider.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/order/presentation/states/order_states.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:e_tantana/shared/widget/popup/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuccessErrorListener extends ConsumerWidget {
  final Widget child;
  const SuccessErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _showFilteredError({
      required BuildContext context,
      required WidgetRef ref,
      required Failure failure,
      required dynamic action,
      required String title,
    }) {
      final now = DateTime.now();
      final lastErrorTime = ref.read(lastNetworkErrorTimeProvider);
      final isNetworkError =
          failure is NetworkFailure || failure.code == 'Network_01';

      if (isNetworkError) {
        if (lastErrorTime == null ||
            now.difference(lastErrorTime).inSeconds > 3) {
          ref.read(lastNetworkErrorTimeProvider.notifier).state = now;

          final msg = SuccesErrorManager.getFriendlyErrorMessage(
            failure,
            action,
          );
          Snackbar.show(
            context,
            message: msg,
            isError: true,
            isPersistent: true,
          );
        }
      } else {
        final String msg = action?.errorMessage ?? failure.message;
        showToast(context, description: msg, isError: true, title: title);
      }
    }

    ref.listen<ProductState>(productControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        _showFilteredError(
          context: context,
          ref: ref,
          failure: next.error!,
          action: next.action,
          title: "Erreur produit",
        );
      }

      if (prev?.isLoading == true &&
          next.isLoading == false &&
          next.error == null) {
        if (next.action?.isWriteAction == true) {
          showToast(
            context,
            description: next.action!.successMessage,
            isError: false,
            title: "Succès",
          );
        }
      }
    });

    ref.listen<OrderStates>(orderControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        _showFilteredError(
          context: context,
          ref: ref,
          failure: next.error!,
          action: next.action,
          title: "Erreur commande",
        );
      }

      if (prev?.isLoading == true &&
          next.isLoading == false &&
          next.error == null) {
        if (next.action?.isWriteAction == true) {
          showToast(
            context,
            description: next.action!.successMessage,
            isError: false,
            title: "Succès commande",
          );
        }
      }
    });

    ref.listen<AuthStates>(authControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        _showFilteredError(
          context: context,
          ref: ref,
          failure: next.error!,
          action: next.action,
          title: "Erreur Auth",
        );
      }

      if (prev?.isLoading == true &&
          next.isLoading == false &&
          next.error == null) {
        if (next.action?.isWriteAction == true) {
          showToast(
            context,
            description: next.action!.successMessage,
            isError: false,
            title: "Succès Auth",
          );
        }
      }
    });

    ref.listen<ShopStates>(shopControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        _showFilteredError(
          context: context,
          ref: ref,
          failure: next.error!,
          action: next.action,
          title: "Erreur Shop",
        );
      }

      if (prev?.isLoading == true &&
          next.isLoading == false &&
          next.error == null) {
        if (next.action?.isWriteAction == true) {
          showToast(
            context,
            description: next.action!.successMessage,
            isError: false,
            title: "Succès Shop",
          );
        }
      }
    });

    ref.listen<UserStates>(userControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        _showFilteredError(
          context: context,
          ref: ref,
          failure: next.error!,
          action: next.action,
          title: "Erreur User",
        );
      }

      if (prev?.isLoading == true &&
          next.isLoading == false &&
          next.error == null) {
        if (next.action?.isWriteAction == true) {
          showToast(
            context,
            description: next.action!.successMessage,
            isError: false,
            title: "Succès User",
          );
        }
      }
    });

    return child;
  }
}
