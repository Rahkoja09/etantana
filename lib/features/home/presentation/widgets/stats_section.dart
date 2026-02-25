import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/home/domain/entities/dashboard_stats_entities.dart';
import 'package:e_tantana/features/home/presentation/controller/dashboard_controller.dart';
import 'package:e_tantana/features/home/presentation/states/dashboard_states.dart';
import 'package:e_tantana/features/home/presentation/widgets/big_stat_view.dart';
import 'package:e_tantana/features/home/presentation/widgets/stat_number_view.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatsSection extends ConsumerStatefulWidget {
  const StatsSection({super.key});

  @override
  ConsumerState<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends ConsumerState<StatsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getDashboard();
    });
  }

  DashboardStatsEntities dashboard = DashboardStatsEntities(
    period: "loading",
    revenue: 0.0,
    revenueIncrease: "+0%",
    totalOrders: 0,
    deliveryToday: 0,
  );

  Future<void> getDashboard() async {
    await ref
        .read(dashboardStatsControllerProvider.notifier)
        .getDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardStatsControllerProvider);
    ref.listen<DashboardStates>(dashboardStatsControllerProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        showToast(
          context,
          title: 'Erreur de récuperation des donnée de board.',
          isError: true,
          description: next.errorMessage!,
        );
      } else if (next.dashboard != null) {
        setState(() {
          dashboard = next.dashboard!;
        });
      }
    });
    return AppRefreshIndicator(
      onRefresh: getDashboard,
      child: Skeletonizer(
        enabled: dashboardState.isLoading,
        ignoreContainers: true,
        effect: LoadingEffect.getCommonEffect(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MediumTitleWithDegree(
                  showDegree: false,
                  title: "Tableau de bord",
                ),
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
            SizedBox(height: 10.h),
            BigStatView(
              icon: HugeIcons.strokeRoundedMoneyBag01,
              title: "Chiffres d'affaire",
              cycle: "${dashboard.period}",
              moneySign: "Ariary",
              increasePercent: "${dashboard.revenueIncrease}",
              value: "${dashboard.revenue}",
              themeColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
            SizedBox(height: StylesConstants.spacerContent),
            Row(
              children: [
                Expanded(
                  child: StatNumberView(
                    icon: HugeIcons.strokeRoundedInvoice,
                    title: "Commande(s)",
                    value: "${dashboard.totalOrders}",
                  ),
                ),
                SizedBox(width: StylesConstants.spacerContent),
                Expanded(
                  child: StatNumberView(
                    icon: HugeIcons.strokeRoundedPackage03,
                    title: "Livraison(s)",
                    value: "${dashboard.deliveryToday}",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
