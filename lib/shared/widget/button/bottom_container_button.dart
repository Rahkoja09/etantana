import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomContainerButton extends StatelessWidget {
  final VoidCallback onValidate;
  final VoidCallback onBack;
  final String nextBtnText;
  final String prevBtnText;
  const BottomContainerButton({
    super.key,
    required this.onValidate,
    required this.onBack,
    this.prevBtnText = "Retour",
    this.nextBtnText = "Valider",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 60.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(StylesConstants.borderRadius),
          bottomRight: Radius.circular(StylesConstants.borderRadius),
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Row(
            children: [
              Button(
                onTap: onValidate,
                btnText: nextBtnText,
                btnColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
