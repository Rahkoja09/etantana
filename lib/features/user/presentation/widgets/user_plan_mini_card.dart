import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserPlanMiniCard extends StatelessWidget {
  final String userPlan;
  const UserPlanMiniCard({super.key, required this.userPlan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: Text(
        userPlan,
        style: TextStyles.bodyMedium(
          context: context,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
