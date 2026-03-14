import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/stockPrediction/domain/entity/stock_prediction_entity.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/features/stockPrediction/presentation/pages/stock_prediction_settings_page.dart';
import 'package:e_tantana/features/stockPrediction/presentation/widgets/stock_prediction_card.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/others/empty_content_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum _SortMode { pressure, sales, stock }

class StockPredictionPage extends ConsumerStatefulWidget {
  const StockPredictionPage({super.key});

  @override
  ConsumerState<StockPredictionPage> createState() =>
      _StockPredictionPageState();
}

class _StockPredictionPageState extends ConsumerState<StockPredictionPage> {
  _SortMode _sortMode = _SortMode.pressure;
  String _search = '';
  final TextEditingController _searchController = TextEditingController();

  final List<StockPredictionEntity> fakePredictions = List.generate(
    6,
    (i) => StockPredictionEntity(
      productId: 'fake_$i',
      salesPerWeek: 0,
      currentStock: 0,
      daysRemaining: 0,
      stockPressure: 0.5,
    ),
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<StockPredictionEntity> _sorted(
    List<StockPredictionEntity> list,
    List<ProductEntities>? products,
  ) {
    final filtered =
        _search.isEmpty
            ? list
            : list.where((p) {
              final product = products?.cast<ProductEntities?>().firstWhere(
                (pr) => pr?.id == p.productId,
                orElse: () => null,
              );
              return product?.name?.toLowerCase().contains(
                    _search.toLowerCase(),
                  ) ??
                  false;
            }).toList();

    switch (_sortMode) {
      case _SortMode.pressure:
        filtered.sort((a, b) => b.stockPressure.compareTo(a.stockPressure));
        break;
      case _SortMode.sales:
        filtered.sort((a, b) => b.salesPerWeek.compareTo(a.salesPerWeek));
        break;
      case _SortMode.stock:
        filtered.sort((a, b) => a.currentStock.compareTo(b.currentStock));
        break;
    }
    return filtered;
  }

  Future<void> getAllPredictedStock() async {
    return ref.read(stockPredictionControllerProvider.notifier).refreshFull();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockPredictionControllerProvider);
    final products = ref.watch(productControllerProvider).product;
    final isLoading = state.isFullLoading;
    final predictions =
        isLoading
            ? fakePredictions
            : _sorted(state.predictions ?? [], products);

    final criticalCount =
        (state.predictions ?? []).where((p) => p.stockPressure > 0.8).length;
    final warningCount =
        (state.predictions ?? [])
            .where((p) => p.stockPressure > 0.5 && p.stockPressure <= 0.8)
            .length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, criticalCount, warningCount),
            _buildSearchBar(context),
            _buildSortBar(context),
            SizedBox(height: 20),
            Expanded(
              child: AppRefreshIndicator(
                onRefresh: getAllPredictedStock,
                child: Skeletonizer(
                  enabled: isLoading,
                  effect: LoadingEffect.getCommonEffect(context),
                  ignoreContainers: true,
                  child:
                      predictions!.isEmpty && !isLoading
                          ? EmptyContentView(
                            icon: HugeIcons.strokeRoundedChartBubble01,
                            text: "Aucune prédiction disponible.",
                          )
                          : ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            itemCount: predictions.length,
                            itemBuilder: (context, index) {
                              final prediction = predictions[index];
                              final product = products
                                  ?.cast<ProductEntities?>()
                                  .firstWhere(
                                    (p) => p?.id == prediction.productId,
                                    orElse: () => null,
                                  );
                              return StockPredictionCard(
                                imagePath:
                                    isLoading
                                        ? AppConst.defaultImage
                                        : (product?.images ??
                                            AppConst.defaultImage),
                                productName:
                                    isLoading
                                        ? "Nom du produit"
                                        : (product?.name ?? "Inconnu"),
                                salesPerWeek: prediction.salesPerWeek,
                                currentStock: prediction.currentStock,
                                daysRemaining: prediction.daysRemaining,
                                pressure: prediction.stockPressure,
                              );
                            },
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    int criticalCount,
    int warningCount,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),

              // Bouton settings
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StockPredictionSettingsPage(),
                    ),
                  );
                },
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 16.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Titre avec badge IA
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Prédiction de stock",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 8.w),
              _buildAiBadge(context),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "Anticipez les ruptures avant qu'elles arrivent.",
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
          SizedBox(height: 16.h),

          // Résumé statuts
          if (criticalCount > 0 || warningCount > 0)
            _buildStatusSummary(context, criticalCount, warningCount),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildAiBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 10.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 4.w),
          Text(
            "IA",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSummary(BuildContext context, int critical, int warning) {
    return Row(
      children: [
        if (critical > 0)
          _buildStatusChip(
            context,
            label: "$critical critique${critical > 1 ? 's' : ''}",
            color: const Color(0xFFEF4444),
            icon: Icons.warning_amber_rounded,
          ),
        if (critical > 0 && warning > 0) SizedBox(width: 8.w),
        if (warning > 0)
          _buildStatusChip(
            context,
            label: "$warning attention${warning > 1 ? 's' : ''}",
            color: const Color(0xFFF97316),
            icon: Icons.info_outline_rounded,
          ),
      ],
    );
  }

  Widget _buildStatusChip(
    BuildContext context, {
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _search = v),
          style: TextStyle(
            fontSize: 13.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            hintText: "Rechercher un produit...",
            hintStyle: TextStyle(
              fontSize: 13.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.35),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 18.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.35),
            ),
            suffixIcon:
                _search.isNotEmpty
                    ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _search = '');
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 16.sp,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.35),
                      ),
                    )
                    : null,
          ),
        ),
      ),
    );
  }

  Widget _buildSortBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Text(
            "Trier par",
            style: TextStyle(
              fontSize: 11.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          SizedBox(width: 10.w),
          _buildSortChip(context, label: "Urgence", mode: _SortMode.pressure),
          SizedBox(width: 6.w),
          _buildSortChip(context, label: "Ventes", mode: _SortMode.sales),
          SizedBox(width: 6.w),
          _buildSortChip(context, label: "Stock", mode: _SortMode.stock),
        ],
      ),
    );
  }

  Widget _buildSortChip(
    BuildContext context, {
    required String label,
    required _SortMode mode,
  }) {
    final selected = _sortMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _sortMode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color:
              selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color:
                selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
