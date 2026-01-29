import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class PresentationCard extends StatelessWidget {
  final IconData icon;
  final String headText;
  final String bodyText;
  final String commenteText;
  const PresentationCard({
    super.key,
    required this.icon,
    required this.headText,
    required this.bodyText,
    required this.commenteText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      padding: EdgeInsets.all(StylesConstants.spacerContent),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.surface),
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(
            icon: icon,
            color: Theme.of(context).colorScheme.onSurface,
            size: 45.sp,
          ),
          RichText(
            text: TextSpan(
              text: headText,
              style: TextStyles.titleSmall(
                context: context,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: bodyText,
                  style: TextStyles.titleMedium(context: context),
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
    );
  }
}
