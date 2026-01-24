import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/home/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Aperçu",
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
              child: StatCard(
                icon: HugeIcons.strokeRoundedShoppingCart01,
                label: "Commandes",
                value: "24",
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                icon: HugeIcons.strokeRoundedDollar02,
                label: "Recettes (Ar)",
                value: "450 000",
                color: Colors.green.shade600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: HugeIcons.strokeRoundedPackage,
                label: "Produits Actifs",
                value: "85",
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                icon: HugeIcons.strokeRoundedAiView,
                label: "Panier Moyen",
                value: "18 750",
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
