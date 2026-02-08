import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:e_tantana/config/theme/text_styles.dart';

class OrderSummaryFloatingBar extends StatelessWidget {
  final double totalAmount;
  final int itemCount;
  final VoidCallback onValidate;
  final VoidCallback onRestore;
  final VoidCallback onCancel;

  const OrderSummaryFloatingBar({
    super.key,
    required this.totalAmount,
    required this.itemCount,
    required this.onValidate,
    required this.onRestore,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$itemCount article${itemCount > 1 ? 's' : ''} sélectionné${itemCount > 1 ? 's' : ''}",
                  style: TextStyles.bodySmall(context: context).copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  "${totalAmount.toInt()} Ar",
                  style: TextStyles.titleMedium(context: context).copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              _ActionButton(
                icon: HugeIcons.strokeRoundedCancel01,
                color: Colors.red.withValues(alpha: 0.2),
                iconColor: Colors.red.shade300,
                onTap: onCancel,
              ),
              SizedBox(width: 8.w),
              _ActionButton(
                icon: HugeIcons.strokeRoundedCheckmarkSquare04,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                iconColor: Theme.of(context).colorScheme.primary,
                onTap: onValidate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
    );
  }
}
