import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopAvatar extends StatelessWidget {
  final String? logoUrl;
  final double size;

  const ShopAvatar({super.key, this.logoUrl, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: size.r + 8,
      height: size.r + 8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo circle
          Container(
            width: size.r,
            height: size.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: ClipOval(
              child:
                  logoUrl != null
                      ? ImageViewer(imageFileOrLink: logoUrl, borderRadius: 0)
                      : Icon(
                        Icons.storefront_outlined,
                        size: 36.sp,
                        color: primary,
                      ),
            ),
          ),

          // Verified badge
          Positioned(
            bottom: 4.r,
            right: 4.r,
            child: Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.verified_rounded,
                size: 11.sp,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
