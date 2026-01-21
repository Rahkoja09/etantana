import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/home/presentation/widgets/quick_access_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Accès rapide",
          style: TextStyles.bodyText(
            context: context,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        QuickAccessItem(
          icon: HugeIcons.strokeRoundedShoppingCart01,
          title: "Mes commandes",
          subtitle: "Gérer vos commandes en cours",
          color: Theme.of(context).colorScheme.primary,
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        QuickAccessItem(
          icon: HugeIcons.strokeRoundedPackage,
          title: "Inventaire",
          subtitle: "Gérer vos stocks et produits",
          color: Theme.of(context).colorScheme.secondary,
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        QuickAccessItem(
          icon: HugeIcons.strokeRoundedUser,
          title: "Clients",
          subtitle: "Gérer vos clients et contacts",
          color: Theme.of(context).colorScheme.tertiary,
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        QuickAccessItem(
          icon: HugeIcons.strokeRoundedMarketAnalysis,
          title: "Rapports",
          subtitle: "Analyser vos ventes et performances",
          color: Colors.orange.shade400,
          onTap: () {},
        ),
      ],
    );
  }
}
