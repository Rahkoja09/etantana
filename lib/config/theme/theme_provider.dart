import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late ThemeData lightTheme;
late ThemeData darkTheme;

final themeProvider = StateProvider<ThemeData>((ref) => lightTheme);
