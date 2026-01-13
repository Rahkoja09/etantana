import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onTap;
  final String btnText;
  final Color? btnTextColor;
  final bool enableNoBackground;
  final Color btnColor;
  const Button({
    super.key,
    required this.onTap,
    this.btnText = "Suivant",
    this.btnTextColor,
    this.enableNoBackground = false,
    this.btnColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: enableNoBackground ? Colors.transparent : btnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius - 6),
          side: BorderSide(
            color: enableNoBackground ? btnColor : Colors.transparent,
            width: enableNoBackground ? 1 : 0,
          ),
        ),
      ),
      onPressed: onTap,
      child: Text(
        btnText,
        style: TextStyles.buttonText(
          context: context,
          color:
              enableNoBackground
                  ? btnColor
                  : btnTextColor ?? Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
