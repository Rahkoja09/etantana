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
    final theme = ref.watch(themeProvider);
    return AppBar(
      actions: <Widget>[Container()],
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            image: AssetImage(
              theme == lightTheme
                  ? "assets/medias/logos/e_tantana_black.png"
                  : "assets/medias/logos/e_tantana.png",
            ),
            height: 24,
          ),

          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),

                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      ref.read(themeProvider.notifier).state =
                          theme == darkTheme ? lightTheme : darkTheme;
                    });
                  },
                  child: HugeIcon(
                    icon:
                        theme == darkTheme
                            ? HugeIcons.strokeRoundedMoon02
                            : HugeIcons.strokeRoundedSun01,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
