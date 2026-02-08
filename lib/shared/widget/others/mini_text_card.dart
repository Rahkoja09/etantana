import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MiniTextCard extends StatelessWidget {
  final String text;
  final IconData icon;
  const MiniTextCard({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: icon,
            color: Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(text, style: TextStyles.bodyMedium(context: context)),
        ],
      ),
    );
  }
}
