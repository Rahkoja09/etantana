import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class SimpleInput extends StatefulWidget {
  final bool? showIcon;
  final String textHint;
  final IconData iconData;
  final TextEditingController textEditControlleur;
  final int maxLines;
  const SimpleInput({
    super.key,
    this.showIcon = true,
    required this.textHint,
    required this.iconData,
    required this.textEditControlleur,
    required this.maxLines,
  });

  @override
  State<SimpleInput> createState() => _SimpleInputState();
}

class _SimpleInputState extends State<SimpleInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        controller: widget.textEditControlleur,
        style: TextStyles.bodyText(
          context: context,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        cursorColor: Theme.of(context).colorScheme.primary,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          focusColor: Theme.of(context).colorScheme.onSurface,
          hoverColor: Theme.of(context).colorScheme.onSurface,

          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),

          prefixIcon: HugeIcon(
            icon: widget.iconData,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
            size: 20.sp,
          ),

          hintText: widget.textHint,
          hintStyle: TextStyles.bodyText(
            context: context,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          ),
        ),
      ),
    );
  }
}
