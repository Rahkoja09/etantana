import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showCustomPopup({
  required BuildContext context,
  required String title,
  required String description,
  required Widget child,
  required bool isError,
  bool dismissible = true,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return Dialog(
        insetAnimationCurve: Curves.bounceInOut,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        elevation: 4,
        child: Container(
          constraints: BoxConstraints(maxWidth: 350),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header coloré-------------
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color:
                      isError
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.titleMedium(
                        context: context,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      description,
                      style: TextStyles.bodyMedium(
                        context: context,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              /// Contenu dynamique -------------
              Padding(padding: EdgeInsets.all(16.w), child: child),
            ],
          ),
        ),
      );
    },
  );
}
