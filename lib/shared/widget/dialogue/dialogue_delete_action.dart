import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class DialogueDeleteAction extends StatelessWidget {
  final String nameOrID;
  const DialogueDeleteAction({super.key, required this.nameOrID});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(StylesConstants.spacerContent),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius - 6),
        border: Border.all(color: Theme.of(context).colorScheme.error),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Center(
            child: Icon(
              HugeIcons.strokeRoundedDelete04,
              size: 30,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Voulez-vous vraiment supprimer",
            style: TextStyles.bodyMedium(
              context: context,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),

          Text(
            "$nameOrID ?",
            style: TextStyles.bodyMedium(
              context: context,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
