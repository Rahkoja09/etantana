import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomDropdown extends StatelessWidget {
  final String textHint;
  final IconData iconData;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String Function(String)? itemLabelBuilder;

  const CustomDropdown({
    super.key,
    required this.textHint,
    required this.iconData,
    required this.items,
    required this.onChanged,
    this.value,
    this.itemLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      onSaved: (val) {},
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedArrowDown01,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        size: 18.w,
      ),
      style: TextStyles.bodyText(
        context: context,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: HugeIcon(
            icon: iconData,
            color: Theme.of(context).colorScheme.onSurface,
            size: 18.w,
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 40.w),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        hintText: textHint.toUpperCase(),
        hintStyle: TextStyles.bodyText(
          context: context,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        ),
      ),
      items:
          items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                itemLabelBuilder != null ? itemLabelBuilder!(item) : item,
                style: TextStyles.bodyText(
                  context: context,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
      onChanged: onChanged,
      dropdownColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
    );
  }
}
