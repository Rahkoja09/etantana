import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfilHeaderPreview extends StatelessWidget {
  final String imageFileOrLink;
  final String userName;
  final String email;
  final String userPlan;
  final int shopNumber;
  final String jobTitle;

  const ProfilHeaderPreview({
    super.key,
    required this.imageFileOrLink,
    required this.jobTitle,
    required this.shopNumber,
    required this.email,
    required this.userName,
    required this.userPlan,
  });

  bool get _isPremium =>
      userPlan.toLowerCase() == 'premium' || userPlan.toLowerCase() == 'pro';

  Color get _planColor =>
      _isPremium ? const Color(0xFFD4A017) : const Color(0xFF94A3B8);

  String get _planLabel => _isPremium ? "Premium" : "Free";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceBright,
            Color.lerp(colorScheme.surfaceBright, Colors.black, 0.35)!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.surfaceBright.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar + badge plan
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Glow ring
                    Container(
                      width: 68.r,
                      height: 68.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primary.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.2),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: ImageViewer(
                          imageFileOrLink: imageFileOrLink,
                          borderRadius: 68,
                        ),
                      ),
                    ),

                    // Badge plan
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: _planColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primary, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: _planColor.withValues(alpha: 0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Text(
                          _planLabel,
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 16.w),

                // Infos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nom
                      Text(
                        userName.split(' ')[0],
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),

                      // Email
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white.withValues(alpha: 0.65),
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),

                      // Stats pills
                      Row(
                        children: [
                          _StatPill(
                            icon: HugeIcons.strokeRoundedStore01,
                            label:
                                "$shopNumber boutique${shopNumber > 1 ? 's' : ''}",
                          ),
                          SizedBox(width: 8.w),
                          _StatPill(
                            icon: HugeIcons.strokeRoundedUserAccount,
                            label: "@${jobTitle.toLowerCase()}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: icon,
            color: Colors.white.withValues(alpha: 0.8),
            size: 11,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
