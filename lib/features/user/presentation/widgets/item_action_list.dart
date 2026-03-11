import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemActionList extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final double? fontSize;
  final bool showArrow;
  final EdgeInsetsGeometry? padding;
  final Widget? trailing;

  const ItemActionList({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.fontSize,
    this.showArrow = true,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding:
            padding ?? EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(
              leadingIcon,
              size: 20.sp,
              color: iconColor ?? colorScheme.primary,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSize ?? 15.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? colorScheme.onSurface,
                ),
              ),
            ),

            if (trailing != null)
              trailing!
            else if (showArrow)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: colorScheme.onSurface.withOpacity(0.3),
              ),
          ],
        ),
      ),
    );
  }
}
