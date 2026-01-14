import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ShowInputError extends StatelessWidget {
  final String? message;
  final EdgeInsetsGeometry padding;

  const ShowInputError({
    super.key,
    this.message,
    this.padding = const EdgeInsets.only(top: 6.0, left: 2.0),
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox(height: 0);
    }

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message!,
              style: TextStyles.bodySmall(
                context: context,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
