import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle titleLarge({
    required BuildContext context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) => TextStyle(
    decoration: TextDecoration.none,
    color: color ?? Theme.of(context).colorScheme.onSurface,
    fontSize: (fontSize ?? 22.0).sp,
    fontWeight: fontWeight ?? FontWeight.w900,
    fontFamily: 'Nonito',
  );

  static TextStyle titleMedium({
    required BuildContext context,
    Color? color,
    double? fontSize,
  }) => TextStyle(
    decoration: TextDecoration.none,
    color: color ?? Theme.of(context).colorScheme.onSurface,
    fontSize: (fontSize ?? 18.0).sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nonito',
  );

  static TextStyle titleSmall({
    required BuildContext context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) => TextStyle(
    decoration: TextDecoration.none,
    color: color ?? Theme.of(context).colorScheme.onSurface,
    fontSize: (fontSize ?? 16.0).sp,
    fontWeight: fontWeight ?? FontWeight.w500,
    fontFamily: 'Nonito',
  );

  static TextStyle bodyText({
    required BuildContext context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) => TextStyle(
    decoration: TextDecoration.none,
    color: (color ?? Theme.of(context).colorScheme.onSurface),
    fontSize: (fontSize ?? 14.0).sp,
    fontWeight: fontWeight ?? FontWeight.normal,
    fontFamily: 'Nonito',
  );

  static TextStyle bodyMedium({
    required BuildContext context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) => TextStyle(
    decoration: TextDecoration.none,
    color: (color ?? Theme.of(context).colorScheme.onSurface),
    fontSize: (fontSize ?? 12.0).sp,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontFamily: 'Nonito',
  );

  static TextStyle bodySmall({
    required BuildContext context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) => TextStyle(
    decoration: TextDecoration.none,
    color: (color ?? Theme.of(context).colorScheme.onSurface).withValues(
      alpha: 0.9,
    ),
    fontSize: (fontSize ?? 10.0).sp,
    fontWeight: fontWeight ?? FontWeight.w400,
    fontFamily: 'Nonito',
  );

  static TextStyle buttonText({
    required BuildContext context,
    Color? color,
    double? fontSize,
  }) => TextStyle(
    decoration: TextDecoration.none,
    color: color ?? Theme.of(context).colorScheme.onSurface,
    fontSize: (fontSize ?? 14.0).sp,
    fontWeight: FontWeight.w600,
  );
}
