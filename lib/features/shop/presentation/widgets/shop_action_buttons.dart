import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class ShopActionButtons extends StatelessWidget {
  final VoidCallback? onQrTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const ShopActionButtons({
    super.key,
    this.onQrTap,
    this.onEditTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        // QR Shop bouton principal
        Expanded(
          child: GestureDetector(
            onTap: onQrTap,
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: isDark ? primary : Colors.black,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? primary : Colors.black).withValues(
                      alpha: 0.25,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 18.sp,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "QR Shop",
                    style: TextStyles.bodyText(
                      context: context,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),

        // Share
        _IconBtn(icon: HugeIcons.strokeRoundedEdit04, onTap: onEditTap),
        SizedBox(width: 10.w),

        // Favorite
        _IconBtn(
          icon:
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
          iconColor:
              isFavorite
                  ? const Color(0xFFEF4444)
                  : Theme.of(context).colorScheme.onSurface,
          onTap: onFavoriteTap,
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _IconBtn({required this.icon, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 19.sp,
          color: iconColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
