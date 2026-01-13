import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class ModerneOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  const ModerneOptionCard({
    super.key,
    required BuildContext context,
    this.icon = HugeIcons.strokeRoundedActivity01,
    this.title = "This.title",
    this.subtitle = "This.subtitle",
    required this.onTap,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? onTap : null,
      borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color:
              isActive
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          border: Border.all(
            color:
                !isActive
                    ? Theme.of(context).colorScheme.surfaceContainer
                    : Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
              child: HugeIcon(
                icon: icon,
                color:
                    isActive
                        ? Colors.black
                        : Colors.white.withValues(alpha: 0.3),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.titleSmall(
                      context: context,
                      fontWeight: FontWeight.w600,
                      color:
                          isActive
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyles.bodyMedium(
                      context: context,
                      fontWeight: FontWeight.w300,
                      color:
                          isActive
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color:
                  isActive
                      ? Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4)
                      : Theme.of(context).colorScheme.surfaceContainer,
            ),
          ],
        ),
      ),
    );
  }
}
