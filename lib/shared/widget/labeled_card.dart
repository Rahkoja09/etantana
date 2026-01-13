import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class LabeledCard extends StatelessWidget {
  final String label;
  final Widget child;

  const LabeledCard({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
              border: Border.all(color: scheme.onSurface, width: 0.7),
              color: scheme.surfaceContainerLow,
            ),
            child: child,
          ),
          Positioned(
            top: 0,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  StylesConstants.borderRadius,
                ),
              ),
              child: Text(
                label,
                style: TextStyles.bodyText(
                  context: context,
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
