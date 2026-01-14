import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';

class DateSelector {
  /// Sélecteur d'une seule date -----------
  static Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? minDate,
    DateTime? maxDate,
    bool useFallback = true,
    String title = "Choisir la date",
  }) async {
    try {
      final pickedDate = await showBoardDateTimePickerForDate(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        minimumDate: minDate ?? DateTime(1900),
        maximumDate: maxDate ?? DateTime(2100),
        options: BoardDateTimeOptions(
          boardTitle: title,
          boardTitleTextStyle: TextStyles.titleSmall(
            context: context,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          activeColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          pickerFormat: PickerFormat.dmy,
          useResetButton: true,
          languages: BoardPickerLanguages(
            locale: 'fr',
            today: 'Aujourd’hui',
            tomorrow: 'Demain',
            now: 'Maintenant',
            yesterday: 'Hier',
          ),
        ),
      );
      return pickedDate;
    } catch (e) {
      if (!useFallback) return null;
      return await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: minDate ?? DateTime(1900),
        lastDate: maxDate ?? DateTime(2100),
      );
    }
  }

  /// Sélecteur d'une plage de dates ------------
  static Future<DateTimeRange?> pickDateRange({
    required BuildContext context,
    DateTimeRange? initialRange,
    DateTime? minDate,
    DateTime? maxDate,
    bool useFallback = true,
    String title = "Intervalle de date",
  }) async {
    try {
      final result = await showBoardDateTimeMultiPicker(
        context: context,
        pickerType: DateTimePickerType.date,
        minimumDate: minDate ?? DateTime(1950, 1, 1),
        maximumDate: maxDate ?? DateTime(2060, 1, 1),
        dateRangeMode: MultiPickerDateRangeMode.flexible,
        startDate: initialRange?.start,
        endDate: initialRange?.end,

        options: BoardDateTimeOptions(
          boardTitle: title,
          boardTitleTextStyle: TextStyles.titleSmall(
            context: context,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          activeColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          pickerFormat: PickerFormat.dmy,

          useResetButton: true,
          languages: BoardPickerLanguages(
            locale: 'fr',
            today: 'Aujourd’hui',
            tomorrow: 'Demain',
            now: 'Maintenant',
            yesterday: 'Hier',
          ),
        ),
      );

      if (result != null) {
        DateTime start, end;
        try {
          start = (result as dynamic).startDate ?? result.start;
          end = (result as dynamic).endDate ?? result.end;
        } catch (_) {
          start = (result as dynamic).start ?? result.start;
          end = (result as dynamic).end ?? result.end;
        }
        return DateTimeRange(start: start, end: end);
      }
      return null;
    } catch (e) {
      if (!useFallback) return null;
      return await showDateRangePicker(
        context: context,
        firstDate: minDate ?? DateTime(1900),
        lastDate: maxDate ?? DateTime(2100),
        initialDateRange: initialRange,
      );
    }
  }
}
