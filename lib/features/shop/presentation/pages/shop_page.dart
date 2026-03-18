import 'dart:ui';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/providers/shop/active_shop_provider.dart';
import 'package:e_tantana/core/providers/shop/shop_switch_loading_provider.dart';
import 'package:e_tantana/features/delivring/presentation/controller/delivering_controller.dart';
import 'package:e_tantana/features/home/presentation/controller/dashboard_controller.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:e_tantana/features/shop/presentation/controller/shop_controller.dart';
import 'package:e_tantana/features/shop/presentation/pages/create_shop_page.dart';
import 'package:e_tantana/features/shop/presentation/widgets/shop_action_buttons.dart';
import 'package:e_tantana/features/shop/presentation/widgets/shop_avatar.dart';
import 'package:e_tantana/features/shop/presentation/widgets/shop_info_cards.dart';
import 'package:e_tantana/features/shop/presentation/widgets/shop_product_card.dart';
import 'package:e_tantana/features/shop/presentation/widgets/switch_shop_loading.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/features/user/presentation/controller/user_controller.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShopPage extends ConsumerStatefulWidget {
  final ShopEntity shop;
  const ShopPage({super.key, required this.shop});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  bool _descExpanded = false;

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productControllerProvider);
    final products = productState.product ?? [];
    final isLoading = productState.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final shopProducts =
        products.where((p) => p.shopId == widget.shop.id).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        elevation: 2,
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CreateShopPage()));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          ),
          child: Icon(HugeIcons.strokeRoundedStoreAdd02),
        ),
      ),

      appBar: SimpleAppbar(onBack: () {}, title: "Ma boutique"),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Avatar avec glow
                    ShopAvatar(logoUrl: widget.shop.shopLogo),
                    SizedBox(height: 16.h),

                    // Nom
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        widget.shop.shopName ?? "Boutique",
                        style: TextStyles.titleLarge(context: context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Badge slogan pulsant
                    if (widget.shop.slogan != null &&
                        widget.shop.slogan!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.shop.slogan!.toUpperCase(),
                              style: TextStyles.bodySmall(
                                context: context,
                                fontWeight: FontWeight.w800,
                                color:
                                    isDark
                                        ? primary
                                        : primary.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 14.h),

                    // Description
                    if (widget.shop.description != null &&
                        widget.shop.description!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: GestureDetector(
                          onTap:
                              () => setState(
                                () => _descExpanded = !_descExpanded,
                              ),
                          child: Column(
                            children: [
                              AnimatedCrossFade(
                                firstChild: Text(
                                  widget.shop.description!,
                                  style: TextStyles.bodyMedium(
                                    context: context,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.55),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                secondChild: Text(
                                  widget.shop.description!,
                                  style: TextStyles.bodyMedium(
                                    context: context,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.55),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                crossFadeState:
                                    _descExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 200),
                              ),
                              if (widget.shop.description!.length > 80)
                                Text(
                                  _descExpanded ? "Voir moins" : "Voir plus",
                                  style: TextStyles.bodySmall(
                                    context: context,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                    SizedBox(height: 20.h),

                    // Boutons action
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ShopActionButtons(
                        onSwitchTap: () => _showShopSwitcher(context, ref),
                        onEditTap: () {},
                        onQrTap: () {},
                      ),
                    ),
                    SizedBox(height: 26.h),

                    // Info cards contact
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ShopInfoCards(shop: widget.shop),
                    ),
                    SizedBox(height: 26.h),
                  ],
                ),
              ),

              // Titre section produits
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nouveautés",
                            style: TextStyles.titleMedium(context: context),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: 40.w,
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            "TOUT VOIR",
                            style: TextStyles.bodySmall(
                              context: context,
                              fontWeight: FontWeight.w800,
                              color:
                                  isDark
                                      ? primary
                                      : primary.withValues(alpha: 0.85),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 14.sp,
                            color:
                                isDark
                                    ? primary
                                    : primary.withValues(alpha: 0.85),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Grille produits
              isLoading
                  ? SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Skeletonizer(
                          enabled: true,
                          effect: LoadingEffect.getCommonEffect(context),
                          child: ShopProductCard(product: ProductEntities()),
                        ),
                        childCount: 4,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14.w,
                        mainAxisSpacing: 25.h,
                        childAspectRatio: 0.68,
                      ),
                    ),
                  )
                  : shopProducts.isEmpty
                  ? SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.h),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 38.sp,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.18),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Aucun produit pour l'instant",
                            style: TextStyles.bodyMedium(
                              context: context,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 40.h),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => ShopProductCard(
                          product: shopProducts[i],
                          onAddTap: () {},
                        ),
                        childCount: shopProducts.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14.w,
                        mainAxisSpacing: 25.h,
                        childAspectRatio: 0.68,
                      ),
                    ),
                  ),
            ],
          ),

          if (ref.watch(shopSwitchLoadingProvider) == true) ShopSwitchOverlay(),
        ],
      ),
    );
  }
}

void _showShopSwitcher(BuildContext context, WidgetRef ref) {
  final shops = ref.read(shopControllerProvider).shops ?? [];
  final user = ref.watch(userControllerProvider).users?[0];
  final activeId = ref.read(activeShopIdProvider).id;

  Future<void> updateData() async {
    await ref.read(productControllerProvider.notifier).researchProduct(null);
    await ref.read(orderControllerProvider.notifier).researchOrder(null);
    await ref
        .read(deliveringControllerProvider.notifier)
        .searchDelivering(null);
    await ref
        .read(dashboardStatsControllerProvider.notifier)
        .getDashboardStats();
    await ref.read(stockPredictionControllerProvider.notifier).refreshFull();
    await ref.read(stockPredictionControllerProvider.notifier).refreshHome();
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (_) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                "Mes boutiques",
                style: TextStyles.titleSmall(context: context),
              ),
              SizedBox(height: 14.h),

              ...shops.map((shop) {
                final isActive = shop.id == activeId;
                return GestureDetector(
                  onTap: () async {
                    ref.read(activeShopIdProvider.notifier).state = (
                      id: shop.id,
                      isSwitching: true,
                    );
                    Navigator.pop(context);
                    await ref
                        .read(shopControllerProvider.notifier)
                        .selectShop();
                    final userEntity = user?.copyWith(selectedShop: shop.id);
                    await ref
                        .read(userControllerProvider.notifier)
                        .switchShop(userEntity!, shop.shopName!);
                    await updateData();
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isActive
                              ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.08)
                              : Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isActive
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40.h,
                          width: 40.w,
                          child: ImageViewer(
                            imageFileOrLink: shop.shopLogo,
                            borderRadius: 60,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          shop.shopName ?? "shop_name",
                          style: TextStyles.bodyText(
                            context: context,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w400,
                            color:
                                isActive
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (isActive)
                          Icon(
                            Icons.check_rounded,
                            size: 16.sp,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 8.h),
            ],
          ),
        ),
  );
}
