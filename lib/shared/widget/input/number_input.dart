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
  final String? title;
  final double? height;
  final bool? noBorder;

  const NumberInput({
    super.key,
    required this.value,
    required this.onValueChanged,
    this.minValue = 0,
    this.minusIcon = Icons.remove,
    this.plusIcon = Icons.add,
    this.backgroundColor,
    this.title,
    this.height,
    this.noBorder = false,
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
        if (widget.title != null)
          Flexible(
            child: Text(
              widget.title!,
              style: TextStyles.bodyText(
                context: context,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

        Container(
          height: widget.height ?? 35.h,
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ??
                Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color:
                  widget.noBorder!
                      ? Colors.transparent
                      : Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCompactButton(
                icon: widget.minusIcon,
                onPressed: currentValue > widget.minValue ? _decrement : null,
                enabled: currentValue > widget.minValue,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Center(
                  child: Text(
                    '$currentValue',
                    style: TextStyles.bodyText(
                      context: context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              _buildCompactButton(
                icon: widget.plusIcon,
                onPressed: _increment,
                enabled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactButton({
    required IconData icon,
    VoidCallback? onPressed,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30.w,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Icon(
          icon,
          size: 16.sp,
          color:
              enabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
