import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionIconBox extends StatelessWidget {
  final IconData icon;
  const ActionIconBox({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      child: Icon(
        icon,
        size: 20.sp,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
