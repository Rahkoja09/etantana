import 'package:e_tantana/features/home/presentation/widgets/action_card.dart';
import 'package:e_tantana/shared/widget/text/medium_title_with_degree.dart';
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
        MediumTitleWithDegree(showDegree: false, title: "Actions rapide"),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                color: Colors.blue[900]!,
                icon: HugeIcons.strokeRoundedMoneyAdd01,
                label: "Nouvelle\nvente",
                onTap: () {},
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ActionCard(
                color: Theme.of(context).colorScheme.primary,
                icon: HugeIcons.strokeRoundedGarage,
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
                color: Colors.green,
                icon: HugeIcons.strokeRoundedPackageMoving,
                label: "Ajouter\nfuture produit",
                onTap: () {},
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ActionCard(
                color: Colors.deepOrange[300]!,
                icon: HugeIcons.strokeRoundedInvoice,
                label: "Imprimer\nfacture",
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
