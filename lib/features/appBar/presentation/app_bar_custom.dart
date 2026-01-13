import 'package:e_tantana/config/theme/text_styles.dart';
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
          Text(
            "0_0",
            style: TextStyles.bodyText(
              context: context,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.w, top: 5.h, bottom: 5.h),
                child: GestureDetector(
                  onTap: () {},
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Padding(
                padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),

                child: GestureDetector(
                  onTap: () {},
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedSorting01,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Padding(
                padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),

                child: GestureDetector(
                  onTap: () {},
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedMoon02,
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
