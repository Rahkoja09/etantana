import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/home/presentation/widgets/main_action_section.dart';
import 'package:e_tantana/features/home/presentation/widgets/quick_access_section.dart';
import 'package:e_tantana/features/home/presentation/widgets/quick_search_section.dart';
import 'package:e_tantana/features/home/presentation/widgets/recent_activity_section.dart';
import 'package:e_tantana/features/home/presentation/widgets/stats_section.dart';
import 'package:e_tantana/features/home/presentation/widgets/tools_section.dart';
import 'package:e_tantana/features/home/presentation/widgets/welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(StylesConstants.spacerContent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec salutation --------
                const WelcomeHeader(),
                SizedBox(height: 30.h),

                // Section Stats ----------
                const StatsSection(),
                SizedBox(height: 32.h),

                // Section Recherche rapide --------
                const QuickSearchSection(),
                SizedBox(height: 32.h),

                // Section Actions principales- ----------------
                const MainActionsSection(),
                SizedBox(height: 32.h),

                // Section Accès rapide -----
                const QuickAccessSection(),
                SizedBox(height: 32.h),

                // Section Récent/Favoris--------
                const RecentActivitySection(),
                SizedBox(height: 32.h),

                // Section Outils utiles -----------------
                const ToolsSection(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
