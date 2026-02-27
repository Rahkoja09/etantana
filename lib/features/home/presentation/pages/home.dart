import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/home/presentation/controller/dashboard_controller.dart';
import 'package:e_tantana/features/home/presentation/widgets/main_action_section.dart';
import 'package:e_tantana/features/home/presentation/widgets/stats_section.dart';
import 'package:e_tantana/features/home/presentation/widgets/stock_prediction.dart';
import 'package:e_tantana/features/home/presentation/widgets/welcome_header.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool showHi = false;

  void _triggerBoom() {
    setState(() => showHi = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => showHi = false);
    });
  }

  Future<void> refreshHomePage() async {
    ref.read(dashboardStatsControllerProvider.notifier).getDashboardStats();
    ref.read(stockPredictionControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final double spacerSection = 25.h;
    return AppRefreshIndicator(
      onRefresh: refreshHomePage,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(StylesConstants.spacerContent),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header avec salutation --------
                      WelcomeHeader(
                        onTap: () {
                          _triggerBoom();
                        },
                      ),
                      SizedBox(height: spacerSection),

                      // Section Stats ----------
                      const StatsSection(),
                      SizedBox(height: spacerSection),

                      // stock prediction list -------
                      StockPrediction(),
                      SizedBox(height: spacerSection),

                      // Section Actions principales- ----------------
                      const MainActionsSection(),
                      SizedBox(height: spacerSection),
                    ],
                  ),
                ),
                if (showHi)
                  IgnorePointer(
                    child: Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/medias/animations/hi.json',
                            repeat: false,
                            onLoaded: (composition) {},
                          ),
                          Container(
                            width: 280,
                            padding: EdgeInsets.all(
                              StylesConstants.spacerContent,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.onSurface,
                                  Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                StylesConstants.borderRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bonjour 👋",
                                        style: TextStyles.titleSmall(
                                          context: context,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                      Text(
                                        "Future Milliardaire",
                                        style: TextStyles.titleMedium(
                                          context: context,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
