import 'package:intl/intl.dart';

String formatPrice(String input) {
  String cleanedInput = input.replaceAll(RegExp(r'[^0-9]'), '');

  int value = int.tryParse(cleanedInput) ?? 0;

  final formatter = NumberFormat('#,###', 'fr_FR');
  return formatter.format(value);
}

String formatSmartPrice(dynamic input) {
  final formatter = NumberFormat('#,###', 'fr_FR');

  if (input is num) {
    return formatter.format(input);
  } else if (input is String) {
    return formatPrice(input);
  } else {
    return "0";
  }
}

String removeSpaces(String input) {
  return input.replaceAll(' ', '');
}
