import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberInput extends StatefulWidget {
  final int value;
  final ValueChanged<int> onValueChanged;
  final int minValue;
  final IconData minusIcon;
  final IconData plusIcon;
  final Color? backgroundColor;
  final String title;

  const NumberInput({
    super.key,
    required this.value,
    required this.onValueChanged,
    this.minValue = 0,
    this.minusIcon = Icons.remove,
    this.plusIcon = Icons.add,
    this.backgroundColor,
    this.title = "Title of section",
  });

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.value;
  }

  void _increment() {
    setState(() {
      currentValue++;
    });
    widget.onValueChanged(currentValue);
  }

  void _decrement() {
    if (currentValue > widget.minValue) {
      setState(() {
        currentValue--;
      });
      widget.onValueChanged(currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: TextStyles.bodyText(
            context: context,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ??
                Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: currentValue > widget.minValue ? _decrement : null,
                icon: Icon(
                  widget.minusIcon,
                  size: 18.sp,
                  color:
                      currentValue > widget.minValue
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  '$currentValue',
                  style: TextStyles.bodyText(
                    context: context,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _increment,
                icon: Icon(
                  widget.plusIcon,
                  size: 18.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
