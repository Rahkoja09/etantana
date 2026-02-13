import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class PresentationCard extends StatelessWidget {
  final IconData icon;
  final String headText;
  final String bodyText;
  final String commenteText;
  final VoidCallback onTap;
  final Color themeColor;
  const PresentationCard({
    super.key,
    required this.icon,
    required this.headText,
    required this.bodyText,
    required this.commenteText,
    required this.onTap,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
        padding: EdgeInsets.all(StylesConstants.spacerContent),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.2,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  StylesConstants.borderRadius,
                ),
              ),
              child: HugeIcon(icon: icon, color: themeColor, size: 30.sp),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: headText,
                    style: TextStyles.titleSmall(
                      context: context,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: bodyText,
                        style: TextStyles.titleMedium(
                          context: context,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  commenteText,
                  style: TextStyles.bodyMedium(
                    context: context,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              child: Button(
                onTap: () {},
                btnText: "Ouvrir",
                btnColor: themeColor,
                btnTextColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
