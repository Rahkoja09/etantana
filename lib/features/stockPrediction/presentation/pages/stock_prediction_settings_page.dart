import 'package:e_tantana/features/stockPrediction/presentation/settings/stock_prediction_setings_notifier.dart';
import 'package:e_tantana/features/stockPrediction/presentation/settings/stock_prediction_settings.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StockPredictionSettingsPage extends ConsumerWidget {
  const StockPredictionSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(stockPredictionSettingsProvider);
    final notifier = ref.read(stockPredictionSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: SimpleAppbar(
        onBack: () => Navigator.pop(context),
        title: "Paramètres de prédiction",
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        children: [
          // Fenêtre de calcul
          MediumTitleWithDegree(
            showDegree: true,
            degree: 1,
            title: "Fenêtre de calcul",
          ),
          SizedBox(height: 6.h),
          Text(
            "Période utilisée pour calculer la vitesse de vente.",
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
          SizedBox(height: 14.h),
          ...StockPredictionWindow.values.map(
            (w) => _buildOptionTile(
              context: context,
              label: w.label,
              subtitle: "${w.days} jour${w.days > 1 ? 's' : ''} de données",
              selected: settings.window == w,
              onTap: () => notifier.setWindow(w),
            ),
          ),

          SizedBox(height: 32.h),

          // Nombre d'aperçu sur le home
          MediumTitleWithDegree(
            showDegree: true,
            degree: 2,
            title: "Aperçu sur l'accueil",
          ),
          SizedBox(height: 6.h),
          Text(
            "Nombre de produits affichés dans le widget de prédiction.",
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
          SizedBox(height: 14.h),
          _buildCountSelector(context, settings, notifier),

          SizedBox(height: 32.h),

          // Info page dédiée
          _buildInfoBanner(context),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required String label,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color:
              selected
                  ? Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.08)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                selected
                    ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3)
                    : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          selected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 18.r,
              height: 18.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.2),
                  width: 2,
                ),
                color:
                    selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
              ),
              child:
                  selected
                      ? Icon(Icons.check, size: 11.sp, color: Colors.white)
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountSelector(
    BuildContext context,
    StockPredictionSettings settings,
    StockPredictionSettingsNotifier notifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${settings.previewCount} produit${settings.previewCount > 1 ? 's' : ''}",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              _buildCountButton(
                context: context,
                icon: Icons.remove_rounded,
                onTap:
                    settings.previewCount > 1
                        ? () =>
                            notifier.setPreviewCount(settings.previewCount - 1)
                        : null,
              ),
              SizedBox(width: 8.w),
              _buildCountButton(
                context: context,
                icon: Icons.add_rounded,
                onTap:
                    settings.previewCount < 10
                        ? () =>
                            notifier.setPreviewCount(settings.previewCount + 1)
                        : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color:
              enabled
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color:
              enabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14.sp,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.35),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "La page dédiée affiche tous vos produits sans limite.",
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
