import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/home/presentation/widgets/action_card.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class MainActionsSection extends StatelessWidget {
  const MainActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MediumTitleWithDegree(showDegree: false, title: "Actions rapides"),
            InkWell(
              child: Text(
                "voir plus",
                style: TextStyles.bodyMedium(
                  context: context,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                color: Colors.blue[900]!,
                icon: HugeIcons.strokeRoundedMoneyAdd01,
                label: "Nouvelle\nvente",
                onTap: () {
                  context.push("order/add");
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ActionCard(
                color: Theme.of(context).colorScheme.primary,
                icon: HugeIcons.strokeRoundedGarage,
                label: "Ajouter\nproduit",
                onTap: () => context.push("/product/add/false"),
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
                onTap: () => context.push("/product/add/true"),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ActionCard(
                color: Colors.deepOrange[300]!,
                icon: HugeIcons.strokeRoundedInvoice,
                label: "Gerer\nmes commandes",
                onTap: () => context.go("/nav-bar/:2"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
