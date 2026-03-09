import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/shared/widget/loading/loading_animation.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final VoidCallback onTap;
  final String btnText;
  final Color? btnTextColor;
  final bool enableNoBackground;
  final Color btnColor;
  final double? borderRadius;
  final bool? isLoading;
  final String? loadingText;
  const Button({
    super.key,
    required this.onTap,
    this.btnText = "Suivant",
    this.btnTextColor,
    this.enableNoBackground = false,
    this.btnColor = Colors.black,
    this.borderRadius,
    this.isLoading = false,
    this.loadingText = "chargement",
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor:
            widget.enableNoBackground ? Colors.transparent : widget.btnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? StylesConstants.borderRadius - 6,
          ),
          side: BorderSide(
            color:
                widget.enableNoBackground
                    ? widget.btnColor
                    : Colors.transparent,
            width: widget.enableNoBackground ? 1 : 0,
          ),
        ),
      ),
      onPressed: widget.onTap,
      child:
          widget.isLoading == true
              ? Center(
                child: Row(
                  children: [
                    Spacer(),
                    LoadingAnimation.white(size: 15),
                    SizedBox(width: 10),
                    Text(
                      widget.loadingText!,
                      style: TextStyles.buttonText(
                        context: context,
                        color:
                            widget.enableNoBackground
                                ? widget.btnColor
                                : widget.btnTextColor ??
                                    Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              )
              : Text(
                widget.btnText,
                style: TextStyles.buttonText(
                  context: context,
                  color:
                      widget.enableNoBackground
                          ? widget.btnColor
                          : widget.btnTextColor ??
                              Theme.of(context).colorScheme.surface,
                ),
              ),
    );
  }
}
