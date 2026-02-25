import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/config/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class AppBarCustom extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const AppBarCustom({super.key});

  @override
  ConsumerState<AppBarCustom> createState() => _AppBarCustomState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarCustomState extends ConsumerState<AppBarCustom> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.7);
    double iconSize = 25;
    final theme = ref.watch(themeProvider);
    return AppBar(
      toolbarHeight: 100,
      actions: <Widget>[Container()],
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(
                image: AssetImage(
                  theme == lightTheme
                      ? "assets/medias/icons/app_icon.png"
                      : "assets/medias/icons/app_icon.png",
                ),
                height: 15.h,
              ),

              Text(
                "-tantana",
                style: TextStyles.titleSmall(
                  fontSize: 18,
                  context: context,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    ref.read(themeProvider.notifier).state =
                        theme == darkTheme ? lightTheme : darkTheme;
                  });
                },
                icon: Icon(
                  theme == darkTheme
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: theme == darkTheme ? Colors.blue : Colors.amberAccent,
                  size: iconSize,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_rounded,
                  color: iconColor,
                  size: iconSize,
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings_rounded,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
