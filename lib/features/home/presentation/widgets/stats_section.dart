import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/home/presentation/widgets/big_stat_view.dart';
import 'package:e_tantana/features/home/presentation/widgets/stat_number_view.dart';
import 'package:e_tantana/shared/widget/text/medium_title_with_degree.dart';
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
        MediumTitleWithDegree(showDegree: false, title: "Tableau de bord"),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: StatNumberView(
                icon: HugeIcons.strokeRoundedInvoice,
                title: "Commandes",
                value: "6",
              ),
            ),
            SizedBox(width: StylesConstants.spacerContent),
            Expanded(
              child: StatNumberView(
                icon: HugeIcons.strokeRoundedPackage03,
                title: "Produits",
                value: "12",
              ),
            ),
          ],
        ),
        SizedBox(height: StylesConstants.spacerContent),
        BigStatView(
          icon: HugeIcons.strokeRoundedMoneyBag01,
          title: "Chiffres d'affaire",
          cycle: "Aujourd'hui",
          moneySign: "Ariary",
          increasePercent: "+106%",
          value: "350 000",
        ),
      ],
    );
  }
}
