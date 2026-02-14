import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class TitleWithExplaination extends StatelessWidget {
  final String title;
  final String explaination;
  const TitleWithExplaination({
    super.key,
    required this.title,
    required this.explaination,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,

          style: TextStyles.titleSmall(
            context: context,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          explaination,
          style: TextStyles.bodyText(
            context: context,
            color: Colors.grey[600],
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
