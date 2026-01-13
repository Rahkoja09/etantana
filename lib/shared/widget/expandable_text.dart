import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;

  const ExpandableText({super.key, required this.text, this.trimLines = 3});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: TextStyles.bodyText(
              context: context,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w400,
            ),
            softWrap: true,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            maxLines: _expanded ? null : widget.trimLines,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _expanded ? "Fermer" : "Lire la suite",
                style: TextStyles.bodyText(
                  context: context,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
