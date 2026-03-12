import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopInfoCards extends StatelessWidget {
  final ShopEntity shop;

  const ShopInfoCards({super.key, required this.shop});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final cards = <_InfoCardData>[];

    if (shop.phoneContact != null && shop.phoneContact!.isNotEmpty) {
      cards.add(
        _InfoCardData(
          icon: HugeIcons.strokeRoundedCall,
          label: "Contact",
          value: shop.phoneContact!,
          onTap: () => _launch("tel:${shop.phoneContact}"),
        ),
      );
    }

    if (shop.socialContact != null && shop.socialContact!.isNotEmpty) {
      cards.add(
        _InfoCardData(
          icon: HugeIcons.strokeRoundedFacebook01,
          label: "Socials",
          value: shop.socialContact!,
          onTap: () {},
        ),
      );
    }

    if (cards.isEmpty) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.h,
      childAspectRatio: 1.9,
      children: cards.map((c) => _InfoCard(data: c)).toList(),
    );
  }
}

class _InfoCardData {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _InfoCardData({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });
}

class _InfoCard extends StatelessWidget {
  final _InfoCardData data;
  const _InfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                data.icon,
                size: 15.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label.toUpperCase(),
                  style: TextStyles.bodySmall(
                    context: context,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  data.value,
                  style: TextStyles.bodySmall(
                    context: context,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
