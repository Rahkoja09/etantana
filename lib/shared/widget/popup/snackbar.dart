import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class Snackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = true,
    bool isPersistent = false,
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        backgroundColor:
            isError
                ? const Color.fromARGB(255, 178, 106, 106)
                : const Color.fromARGB(255, 84, 161, 88),
        duration:
            isPersistent ? const Duration(days: 1) : const Duration(seconds: 4),
        content: Row(
          children: [
            Icon(
              isError ? Icons.wifi_off_rounded : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyles.bodyMedium(
                  context: context,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: isPersistent ? 'FERMER' : 'OK',
          textColor: Colors.white,
          backgroundColor: Colors.black38,
          onPressed: () {
            if (onRetry != null) onRetry();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
