import 'dart:ui';

import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:e_tantana/features/shop/presentation/controller/shop_controller.dart';
import 'package:e_tantana/features/shop/presentation/widgets/shop_action_buttons.dart';
import 'package:e_tantana/features/shop/presentation/widgets/shop_avatar.dart';
import 'package:e_tantana/features/shop/presentation/widgets/shop_info_cards.dart';
import 'package:e_tantana/features/shop/presentation/widgets/shop_product_card.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';

import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
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
  bool _isFavorite = false;
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
                        isFavorite: _isFavorite,
                        onFavoriteTap:
                            () => setState(() => _isFavorite = !_isFavorite),
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
        ],
      ),
    );
  }
}
