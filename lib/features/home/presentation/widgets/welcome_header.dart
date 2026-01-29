import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/home/presentation/widget/presentation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class WelcomeHeader extends StatefulWidget {
  const WelcomeHeader({super.key});

  @override
  State<WelcomeHeader> createState() => _WelcomeHeaderState();
}

class _WelcomeHeaderState extends State<WelcomeHeader>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125.h,
      child: PageView.builder(
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PresentationCard(
                  icon: HugeIcons.strokeRoundedPackage,
                  headText: "Je",
                  bodyText: "Gere",
                  commenteText: "Mes Produit, commandes et factures",
                ),
                SizedBox(width: StylesConstants.spacerContent),
                PresentationCard(
                  icon: HugeIcons.strokeRoundedChartLineData01,
                  headText: "Je",
                  bodyText: "Revise",
                  commenteText: "Mes Statistiques, Recettes et inventaires",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
