import 'package:e_tantana/core/error/error_manager.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalErrorListener extends ConsumerWidget {
  final Widget child;
  const GlobalErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool _isWriteAction(dynamic action) {
      final str = action.toString().toLowerCase();
      return str.contains('insert') ||
          str.contains('delete') ||
          str.contains('update');
    }

    ref.listen<ProductState>(productControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        final msg = SuccesErrorManager.getFriendlyErrorMessage(
          next.error!,
          next.action,
        );
        showToast(context, description: msg, isError: true, title: "Erreur");
      }
      if (prev?.isLoading == true &&
          next.isLoading == false &&
          next.error == null) {
        if (_isWriteAction(next.action)) {
          final msg = SuccesErrorManager.getFriendlySuccessMessage(next.action);
          showToast(context, description: msg, isError: false, title: "Succès");
        }
      }
    });

    return child;
  }
}
