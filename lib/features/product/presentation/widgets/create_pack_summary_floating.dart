import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class CreatePackSummaryFloating extends StatefulWidget {
  final int packCompositionLenght;
  final VoidCallback onCancel;
  final VoidCallback onValidate;
  const CreatePackSummaryFloating({
    super.key,
    required this.packCompositionLenght,
    required this.onValidate,
    required this.onCancel,
  });

  @override
  State<CreatePackSummaryFloating> createState() =>
      _CreatePackSummaryFloatingState();
}

class _CreatePackSummaryFloatingState extends State<CreatePackSummaryFloating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixedDim,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Créer un pack de produit",
                  style: TextStyles.bodySmall(context: context).copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  "${widget.packCompositionLenght} Articles",
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
                onTap: widget.onCancel,
              ),
              SizedBox(width: 8.w),
              _ActionButton(
                icon: HugeIcons.strokeRoundedCheckmarkSquare04,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                iconColor: Theme.of(context).colorScheme.primary,
                onTap: widget.onValidate,
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
