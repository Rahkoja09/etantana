import 'package:e_tantana/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late ThemeData lightTheme;
late ThemeData darkTheme;

final themeProvider = StateProvider<ThemeData>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.isThemeDark() ? darkTheme : lightTheme;
});
