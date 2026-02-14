import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class TitleWithIcon extends StatelessWidget {
  final String title;
  final bool boldTitle;
  final IconData icon;
  final Color? themeColor;
  const TitleWithIcon({
    super.key,
    required this.title,
    required this.boldTitle,
    required this.icon,
    this.themeColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 25, color: themeColor),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyles.titleSmall(
            fontSize: 17,
            context: context,
            fontWeight: boldTitle ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
