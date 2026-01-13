import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  const HorizontalDivider({
    super.key,
    this.height = 1,
    this.width = 20,
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
