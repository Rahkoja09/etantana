import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ListItemAction extends StatelessWidget {
  final bool? noIcon;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const ListItemAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.noIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          noIcon!
              ? null
              : Icon(icon, color: color ?? Theme.of(context).iconTheme.color),
      title: Text(label, style: TextStyle(color: color)),
      trailing:
          noIcon!
              ? HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              )
              : null,
      onTap: onTap,
    );
  }
}
