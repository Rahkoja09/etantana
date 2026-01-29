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
    Color iconColor = Colors.white;
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
          Image(
            image: AssetImage(
              theme == lightTheme
                  ? "assets/medias/icons/app_icon.png"
                  : "assets/medias/icons/app_icon.png",
            ),
            height: 33,
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedNotification03,
                  color: iconColor,
                  size: 25,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    ref.read(themeProvider.notifier).state =
                        theme == darkTheme ? lightTheme : darkTheme;
                  });
                },
                icon: HugeIcon(
                  icon:
                      theme == darkTheme
                          ? HugeIcons.strokeRoundedSun01
                          : HugeIcons.strokeRoundedMoon02,
                  color: iconColor,
                  size: 25,
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedSettings02,
                  color: iconColor,
                  size: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
