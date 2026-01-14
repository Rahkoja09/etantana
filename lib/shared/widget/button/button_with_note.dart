import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ButtonWithNote extends StatefulWidget {
  final String titleBtn;
  final String noteBtn;
  final IconData iconBtn;
  final VoidCallback onTap;
  const ButtonWithNote({
    super.key,
    this.noteBtn = "note of this.button",
    this.titleBtn = "title of this.button",
    this.iconBtn = HugeIcons.strokeRoundedMapsCircle01,
    required this.onTap,
  });

  @override
  State<ButtonWithNote> createState() => _ButtonWithNoteState();
}

class _ButtonWithNoteState extends State<ButtonWithNote> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 1,
          ),
        ),
      ),

      child: Row(
        children: [
          HugeIcon(icon: widget.iconBtn, color: Colors.white, size: 34),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.titleBtn,
                style: TextStyles.buttonText(
                  context: context,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.noteBtn,
                style: TextStyles.bodyMedium(
                  context: context,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
