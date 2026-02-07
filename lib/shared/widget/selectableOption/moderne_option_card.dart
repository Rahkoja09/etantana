import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class ModerneOptionCard extends StatelessWidget {
  final Color cardColor;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  const ModerneOptionCard({
    super.key,
    required this.cardColor,
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
                  ? Theme.of(context).colorScheme.surfaceContainerLowest
                  : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          border: Border.all(color: cardColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
                  width: 0.4,
                ),
              ),
              child: HugeIcon(
                icon: icon,
                color: Theme.of(context).colorScheme.onSurface,
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
                              ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5)
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
