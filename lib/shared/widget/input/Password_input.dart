import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

// ignore: must_be_immutable
class PasswordInput extends StatefulWidget {
  final String textHint;
  final TextEditingController textEditControlleur;
  bool isPassWord;
  PasswordInput({
    super.key,
    required this.textHint,
    required this.textEditControlleur,
    required this.isPassWord,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditControlleur,
      obscureText: !widget.isPassWord,
      style: TextStyles.bodyText(
        context: context,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        focusColor: Theme.of(context).colorScheme.primary,
        prefixIcon: HugeIcon(
          icon: HugeIcons.strokeRoundedLockPassword,

          color: Theme.of(context).colorScheme.onSurface,
          size: 20.w,
        ),

        contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              widget.isPassWord = !widget.isPassWord;
            });
          },
          icon: Icon(
            !widget.isPassWord ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).colorScheme.onSurface,
            size: 17.w,
          ),
        ),

        hintText: widget.textHint,
        hintStyle: TextStyles.bodyText(
          context: context,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        ),
      ),
    );
  }
}
