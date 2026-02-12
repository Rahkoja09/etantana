import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'date_selector.dart';

class DateInput extends StatefulWidget {
  final String textHint;
  final IconData iconData;
  final ValueChanged<DateTime?>? onDateSelected;
  final ValueChanged<DateTimeRange?>? onDateRangeSelected;
  final bool isRange;

  const DateInput({
    super.key,
    required this.textHint,
    required this.iconData,
    this.onDateSelected,
    this.onDateRangeSelected,
    this.isRange = false,
  });

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime? _selectedDate;
  DateTimeRange? _selectedDateRange;

  Future<void> _pickDate() async {
    if (widget.isRange) {
      final result = await DateSelector.pickDateRange(
        context: context,
        initialRange: _selectedDateRange,
      );
      if (result != null) {
        setState(() => _selectedDateRange = result);
        widget.onDateRangeSelected?.call(result);
      }
    } else {
      final result = await DateSelector.pickDate(
        context: context,
        initialDate: _selectedDate,
      );
      if (result != null) {
        setState(() => _selectedDate = result);
        widget.onDateSelected?.call(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText =
        widget.isRange
            ? _selectedDateRange == null
                ? widget.textHint
                : "${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}"
            : _selectedDate == null
            ? widget.textHint
            : DateFormat('dd/MM/yyyy').format(_selectedDate!);

    return InkWell(
      onTap: _pickDate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: widget.iconData,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
              size: 20.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                displayText,
                style: TextStyles.bodyMedium(
                  context: context,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_month,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _pickDate,
            ),
          ],
        ),
      ),
    );
  }
}
