import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/home/presentation/widgets/action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class MainActionsSection extends StatelessWidget {
  const MainActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Actions principales",
          style: TextStyles.bodyText(
            context: context,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                icon: HugeIcons.strokeRoundedAddSquare,
                label: "Nouvelle\nvente",
                onTap: () {},
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ActionCard(
                icon: HugeIcons.strokeRoundedPackage03,
                label: "Ajouter\nproduit",
                onTap: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                icon: HugeIcons.strokeRoundedDownload01,
                label: "Importer",
                onTap: () {},
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ActionCard(
                icon: HugeIcons.strokeRoundedFileExport,
                label: "Exporter",
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
