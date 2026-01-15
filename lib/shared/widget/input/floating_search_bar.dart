import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class FloatingSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSortTap;
  final Function(String)? onChanged;

  const FloatingSearchBar({
    super.key,
    required this.controller,
    required this.onSortTap,
    this.hintText = "RECHERCHER UN PRODUIT...",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      height: 50.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              size: 20.w,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyles.bodyText(context: context),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyles.bodyMedium(
                  context: context,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),

          Container(
            height: 20.h,
            width: 1,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
            margin: EdgeInsets.symmetric(horizontal: 8.w),
          ),

          IconButton(
            onPressed: onSortTap,
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSorting05,
              color: Theme.of(context).colorScheme.primary,
              size: 22.w,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
