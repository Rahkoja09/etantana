import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';

ToastificationItem showToast(
  BuildContext context, {
  bool isError = false,
  required String title,
  String description = "default value of description",
  int duration = 4,
}) {
  return toastification.show(
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    dragToClose: true,
    borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
    borderSide: BorderSide(
      width: 0.5,
      color:
          isError
              ? Theme.of(context).colorScheme.error.withValues(alpha: 0.8)
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
    ),
    icon: HugeIcon(
      icon:
          isError
              ? HugeIcons.strokeRoundedMultiplicationSignCircle
              : HugeIcons.strokeRoundedCheckmarkCircle01,
      color:
          isError
              ? Theme.of(context).colorScheme.error.withValues(alpha: 0.8)
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
    ),
    closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
    primaryColor: Theme.of(context).colorScheme.primary,

    type: isError ? ToastificationType.error : ToastificationType.success,
    title: Text(
      title,
      style: TextStyles.bodyText(context: context, fontWeight: FontWeight.bold),
    ),
    description: Text(
      description,
      style: TextStyles.bodyMedium(
        context: context,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
    autoCloseDuration: Duration(seconds: duration),
    showIcon: true,
    style: ToastificationStyle.flat,
    closeOnClick: true,
  );
}
