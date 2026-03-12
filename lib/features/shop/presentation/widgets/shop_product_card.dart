import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopProductCard extends StatelessWidget {
  final ProductEntities product;
  final VoidCallback? onAddTap;
  final VoidCallback? onTap;

  const ShopProductCard({
    super.key,
    required this.product,
    this.onAddTap,
    this.onTap,
  });

  bool get _isNew {
    if (product.createdAt == null) return false;
    return DateTime.now().difference(product.createdAt!).inDays <= 14;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          Expanded(
            child: Stack(
              children: [
                // Image
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        product.images != null
                            ? ImageViewer(
                              imageFileOrLink: product.images,
                              borderRadius: 0,
                            )
                            : Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 32.sp,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.2),
                              ),
                            ),
                  ),
                ),

                // Dégradé bas
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Badge NEW
                if (_isNew)
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? primary : Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "NEW",
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.black : Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                // Bouton Add
                Positioned(
                  bottom: 10.h,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: onAddTap,
                    child: Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 18.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // Nom
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              product.name ?? "Produit",
              style: TextStyles.bodyMedium(
                context: context,
                fontWeight: FontWeight.w700,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 3.h),

          // Prix
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  product.sellingPrice != null
                      ? _formatPrice(product.sellingPrice!)
                      : "—",
                  style: TextStyles.titleSmall(
                    context: context,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  "Ar",
                  style: TextStyles.bodySmall(
                    context: context,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic price) {
    final n = double.tryParse(price.toString()) ?? 0;
    if (n >= 1000) {
      return "${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}.${(n % 1000).toInt().toString().padLeft(3, '0')}";
    }
    return n.toInt().toString();
  }
}
