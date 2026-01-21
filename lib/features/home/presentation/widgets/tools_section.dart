import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/home/presentation/widgets/tools_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class ToolsSection extends StatelessWidget {
  const ToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Outils utiles",
          style: TextStyles.bodyText(
            context: context,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          children: [
            ToolCard(
              icon: HugeIcons.strokeRoundedCalculator,
              label: "Calculatrice",
              onTap: () {},
            ),
            ToolCard(
              icon: HugeIcons.strokeRoundedCalendar02,
              label: "Calendrier",
              onTap: () {},
            ),
            ToolCard(
              icon: HugeIcons.strokeRoundedSettings04,
              label: "Paramètres",
              onTap: () {},
            ),
            ToolCard(
              icon: HugeIcons.strokeRoundedHelpCircle,
              label: "Aide & Support",
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
