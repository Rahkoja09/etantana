import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwitchButton extends StatelessWidget {
  final bool value;
  final bool isEnabled;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final String? title;
  final bool? showDegree;
  final int? degree;

  const SwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isEnabled,
    this.activeColor,
    this.inactiveColor,
    this.title = "",
    this.showDegree = true,
    this.degree = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MediumTitleWithDegree(
          showDegree: showDegree!,
          degree: degree!,
          title: title ?? "",
        ),
        GestureDetector(
          onTap: isEnabled ? () => onChanged!(!value) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 44.w,
            height: 24.h,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color:
                  (value
                      ? (activeColor ?? Theme.of(context).colorScheme.primary)
                      : (inactiveColor ?? Colors.grey.shade400)),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.bounceInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18.w,
                height: 18.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
