import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class QuickSearchSection extends ConsumerStatefulWidget {
  const QuickSearchSection({super.key});

  @override
  ConsumerState<QuickSearchSection> createState() => _QuickSearchSectionState();
}

class _QuickSearchSectionState extends ConsumerState<QuickSearchSection> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _searchController,
            style: TextStyles.bodyText(
              context: context,
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: "Rechercher...",
              hintStyle: TextStyles.bodyText(
                context: context,
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                  size: 20.w,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedCancel01,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5),
                            size: 20.w,
                          ),
                        ),
                      )
                      : null,
              suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
