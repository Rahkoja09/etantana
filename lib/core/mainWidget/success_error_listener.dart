import 'package:e_tantana/core/error/error_manager.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/mainWidget/last_network_time_provider.dart';
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
    bool _isWriteAction(dynamic action) {
      final str = action.toString().toLowerCase();
      return str.contains('insert') ||
          str.contains('delete') ||
          str.contains('update');
    }

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

      // Si c'est une erreur réseau, on vérifie le délai de 3 secondes -------
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
        // Pour les erreurs hors réseau (ex: métier), on affiche toujours ------------
        final msg = SuccesErrorManager.getFriendlyErrorMessage(failure, action);
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
        if (_isWriteAction(next.action)) {
          final msg = SuccesErrorManager.getFriendlySuccessMessage(next.action);
          showToast(
            context,
            description: msg,
            isError: false,
            title: "Succès produit",
          );
        }
      }
    });

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
        if (_isWriteAction(next.action)) {
          final msg = SuccesErrorManager.getFriendlySuccessMessage(next.action);
          showToast(
            context,
            description: msg,
            isError: false,
            title: "Succès produit",
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
        if (_isWriteAction(next.action)) {
          final msg = SuccesErrorManager.getFriendlySuccessMessage(next.action);
          showToast(
            context,
            description: msg,
            isError: false,
            title: "Succès commande",
          );
        }
      }
    });

    return child;
  }
}
