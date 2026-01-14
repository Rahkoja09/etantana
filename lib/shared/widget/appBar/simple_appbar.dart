import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SimpleAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;

  const SimpleAppbar({super.key, required this.title, required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      title: Text(
        title,
        style: TextStyles.titleSmall(
          context: context,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedCircleArrowLeft01,
          color: Colors.white,
          size: 22,
        ),
        onPressed: onBack,
      ),
      actions: const [SizedBox(width: 48)],
    );
  }
}
