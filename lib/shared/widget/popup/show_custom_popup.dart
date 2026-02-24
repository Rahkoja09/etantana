import 'dart:math' as math;
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showCustomPopup({
  required BuildContext context,
  required String title,
  required String description,
  required Widget child,
  required bool isError,
  void Function()? onTapRightBtn,
  void Function()? onTapLeftBtn,
  String? leftButtonTitle,
  String? rightButtonTitle,
  bool isActionDangerous = false,
  bool dismissible = true,
}) async {
  final double spacerContent = StylesConstants.spacerContent;
  final Color headerColor =
      isError || isActionDangerous
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary;

  final IconData displayIcon =
      isError || isActionDangerous
          ? Icons.warning_rounded
          : Icons.check_circle_sharp;

  await showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 330),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,

                      decoration: BoxDecoration(color: headerColor),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: StylesConstants.spacerContent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: TextStyles.titleMedium(
                                context: context,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              description,
                              style: TextStyles.bodyMedium(
                                context: context,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -20.w,
                      top: -30.h,
                      child: Transform.rotate(
                        angle: -math.pi / 6,
                        child: Icon(
                          displayIcon,
                          size: 100.sp,
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Align(alignment: Alignment.center, child: child),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: spacerContent,
                    right: spacerContent,
                    bottom: spacerContent,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          onTap: onTapLeftBtn ?? () => Navigator.pop(context),
                          btnText: leftButtonTitle ?? "annuler",
                          enableNoBackground: true,
                          btnColor: headerColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Button(
                          onTap: onTapRightBtn ?? () => Navigator.pop(context),
                          btnText: rightButtonTitle ?? "valider",
                          btnColor: headerColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
