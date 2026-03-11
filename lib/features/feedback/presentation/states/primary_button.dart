import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    Key? key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color:
              onTap == null || isLoading
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)
                  : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 16.sp,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
