import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:flutter/material.dart';

class SeparatorBackground extends StatelessWidget {
  final Widget child;
  const SeparatorBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(StylesConstants.spacerContent),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: child,
    );
  }
}
