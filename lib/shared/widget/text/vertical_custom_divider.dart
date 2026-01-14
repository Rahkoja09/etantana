import 'package:flutter/material.dart';

class VerticalCustomDivider extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  const VerticalCustomDivider({
    super.key,
    this.height = 20,
    this.width = 1,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color:
          color ??
          Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
    );
  }
}
