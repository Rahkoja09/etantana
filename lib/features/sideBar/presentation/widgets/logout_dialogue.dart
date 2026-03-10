import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class LogoutDialogue extends StatelessWidget {
  const LogoutDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            HugeIcons.strokeRoundedLogout01,
            size: 30,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 15),
          Text(
            "Voulez-vous vraiment vous deconnecter?",
            style: TextStyles.bodyMedium(context: context),
          ),
        ],
      ),
    );
  }
}
