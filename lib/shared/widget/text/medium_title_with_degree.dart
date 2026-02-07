import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MediumTitleWithDegree extends StatelessWidget {
  final int degree;
  final bool showDegree;
  final String title;
  final String degreeSimbole;
  const MediumTitleWithDegree({
    super.key,
    this.title = "Title of the section.part;",
    this.degree = 1,
    this.showDegree = true,
    this.degreeSimbole = "*",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyles.bodyText(
              context: context,
              fontWeight: FontWeight.w500,
            ),
            children:
                showDegree
                    ? List.generate(
                      degree,
                      (index) => TextSpan(
                        text: " $degreeSimbole",
                        style: TextStyles.bodyMedium(
                          context: context,
                          color:
                              degree == 1
                                  ? Theme.of(context).colorScheme.error
                                  : Colors.green,
                        ),
                      ),
                    )
                    : [TextSpan(text: "")],
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
