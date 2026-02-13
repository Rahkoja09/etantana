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
    Color iconColor = Colors.black;
    double iconSize = 25;
    final theme = ref.watch(themeProvider);
    return AppBar(
      actions: <Widget>[Container()],
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
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
                height: 25.h,
              ),
              SizedBox(width: 10),
              Text(
                "${AppConst.appName}",
                style: TextStyles.titleSmall(
                  fontSize: 18,
                  context: context,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                  color: theme == lightTheme ? Colors.white60 : Colors.black54,
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
