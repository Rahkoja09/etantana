import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceViewer extends StatelessWidget {
  final double? price;
  final String? moneySign;
  final bool showTitle;
  final bool showDegree;
  final int degree;
  final String? title;
  const PriceViewer({
    super.key,
    this.showTitle = false,
    this.showDegree = false,
    this.degree = 1,
    this.title = "default title",
    this.moneySign,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          MediumTitleWithDegree(
            showDegree: showDegree,
            title: title!,
            degree: degree,
          ),
          const SizedBox(height: 5),
        ],

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(
              "$price ${moneySign ?? "Ar"}",
              style: TextStyle(
                fontFamily: 'Nonito',
                fontSize: 12.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
