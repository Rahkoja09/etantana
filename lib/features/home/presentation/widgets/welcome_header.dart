import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/home/presentation/widgets/presentation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class WelcomeHeader extends StatefulWidget {
  final VoidCallback onTap;
  const WelcomeHeader({super.key, required this.onTap});

  @override
  State<WelcomeHeader> createState() => _WelcomeHeaderState();
}

class _WelcomeHeaderState extends State<WelcomeHeader>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          PresentationCard(
            onTap: widget.onTap,
            icon: HugeIcons.strokeRoundedPackage,
            headText: "Je",
            bodyText: "Gère",
            commenteText: "Mes Produits, commandes et factures",
            themeColor: Colors.blue,
          ),
          SizedBox(width: StylesConstants.spacerContent),
          PresentationCard(
            onTap: widget.onTap,
            icon: HugeIcons.strokeRoundedChartLineData01,
            headText: "Je",
            bodyText: "Révise",
            commenteText: "Mes Statistiques, Recettes et inventaires",
            themeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
