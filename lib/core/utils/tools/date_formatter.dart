class DateFormatter {
  static String formatDate({
    required DateTime startDate,
    DateTime? endDate,
    bool showYear = true,
  }) {
    // Format personnalisé des mois -----------
    const months = [
      "Janv",
      "Févr",
      "Mars",
      "Avr",
      "Mai",
      "Juin",
      "Juil",
      "Août",
      "Sept",
      "Oct",
      "Nov",
      "Déc",
    ];

    String formatSingle(DateTime date) {
      final month = months[date.month - 1];
      final day = date.day.toString().padLeft(2, '0');
      final year = "(${date.year})";
      return "$month $day${showYear ? " $year" : ""}";
    }

    // une seule date ------
    if (endDate == null || startDate.isAtSameMomentAs(endDate)) {
      return formatSingle(startDate);
    }

    // plage de dates ------------------
    final sameYear = startDate.year == endDate.year;
    final startMonth = months[startDate.month - 1];
    final endMonth = months[endDate.month - 1];

    final startDay = startDate.day.toString().padLeft(2, '0');
    final endDay = endDate.day.toString().padLeft(2, '0');

    String yearLabel = "";
    if (showYear) {
      if (sameYear) {
        yearLabel = " (${startDate.year})";
      } else {
        yearLabel = " (${startDate.year}) - (${endDate.year})";
      }
    }

    return "$startMonth $startDay - $endMonth $endDay$yearLabel";
  }
}
