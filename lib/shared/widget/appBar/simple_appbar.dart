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
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 2,
      shadowColor: Colors.grey,

      title: Text(
        title,
        style: TextStyles.titleMedium(
          context: context,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: Theme.of(context).colorScheme.onSurface,
          size: 22,
        ),
        onPressed: onBack,
      ),
      actions: const [SizedBox(width: 48)],
    );
  }
}
