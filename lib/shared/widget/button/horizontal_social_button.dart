import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';

class HorizontalSocialButton extends StatelessWidget {
  final String socialIconLinkOrAsset;
  final String title;
  final VoidCallback onTap;
  const HorizontalSocialButton({
    super.key,
    required this.socialIconLinkOrAsset,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: ColorScheme.surfaceContainer,

          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: ImageViewer(imageFileOrLink: socialIconLinkOrAsset),
            ),
            Text(title, style: TextStyles.bodyMedium(context: context)),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
