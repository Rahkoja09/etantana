import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChipSelector extends StatefulWidget {
  final List<String> options;
  final bool multiSelect;
  final ValueChanged<List<String>> onSelectionChanged;
  final String? label;

  const ChipSelector({
    Key? key,
    required this.options,
    this.multiSelect = true,
    required this.onSelectionChanged,
    this.label,
  }) : super(key: key);

  @override
  State<ChipSelector> createState() => _ChipSelectorState();
}

class _ChipSelectorState extends State<ChipSelector> {
  final List<String> _selected = [];

  void _toggle(String option) {
    setState(() {
      if (widget.multiSelect) {
        _selected.contains(option)
            ? _selected.remove(option)
            : _selected.add(option);
      } else {
        _selected
          ..clear()
          ..add(option);
      }
    });
    widget.onSelectionChanged(List.from(_selected));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 8.h),
        ],
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children:
              widget.options.map((option) {
                final isSelected = _selected.contains(option);
                return GestureDetector(
                  onTap: () => _toggle(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
