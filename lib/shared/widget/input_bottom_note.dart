import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class InputBottomNote extends StatelessWidget {
  final String value;
  const InputBottomNote({super.key, this.value = "the value of this.note"});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyles.bodyMedium(
            context: context,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
