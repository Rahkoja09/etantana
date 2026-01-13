import 'package:e_tantana/shared/widget/input/item_manager_section.dart';
import 'package:flutter/material.dart';

class VariantParser {
  static String stringify(List<ProductVariant> items) {
    return items
        .map((item) => "${item.key}(${item.size}, ${item.quantity})")
        .join(", ");
  }

  static List<ProductVariant> parse(String rawString) {
    if (rawString.isEmpty) return [];

    List<ProductVariant> result = [];
    final entries = rawString.split(RegExp(r'\), \s*|\),'));

    for (var entry in entries) {
      if (entry.trim().isEmpty) continue;

      try {
        final cleanEntry = entry.replaceAll(')', '').trim();
        final parts = cleanEntry.split('(');
        final key = parts[0].trim();
        final details = parts[1].split(',');

        result.add(
          ProductVariant(
            key: key,
            size: details[0].trim(),
            quantity: int.parse(details[1].trim()),
          ),
        );
      } catch (e) {
        debugPrint("Erreur de parsing pour l'entrée: $entry");
      }
    }
    return result;
  }
}
