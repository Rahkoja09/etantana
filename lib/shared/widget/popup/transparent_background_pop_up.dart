import 'package:flutter/material.dart';

class TransparentBackgroundPopUp extends StatelessWidget {
  final Widget widget;
  const TransparentBackgroundPopUp({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      child: Center(child: widget),
    );
  }
}
