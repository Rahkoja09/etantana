import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
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
  final String valueOfCardText;
  final IconData valueOfCardIcon;
  final String image3DStyleAssetsOrLink;
  const PresentationCard({
    super.key,
    required this.icon,
    required this.headText,
    required this.bodyText,
    required this.commenteText,
    required this.onTap,
    required this.themeColor,
    required this.valueOfCardText,
    required this.valueOfCardIcon,
    required this.image3DStyleAssetsOrLink,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        child: Stack(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: [
            Container(
              width: 300.w,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(
                  StylesConstants.borderRadius,
                ),
                color: themeColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: headText,
                          style: TextStyles.titleSmall(
                            context: context,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: bodyText,
                              style: TextStyles.titleMedium(
                                context: context,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2),
                      Container(
                        width: 150,
                        child: Text(
                          commenteText,
                          style: TextStyles.bodyMedium(
                            context: context,
                            color: Colors.white.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              valueOfCardIcon,
                              size: 15,
                              color: Colors.black,
                            ),
                            SizedBox(width: 5),
                            Text(
                              valueOfCardText,
                              style: TextStyles.bodyMedium(
                                context: context,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowRight01,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -40,
              right: -40,
              child: SizedBox(
                width: 150,
                height: 140,
                child: ImageViewer(imageFileOrLink: image3DStyleAssetsOrLink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
