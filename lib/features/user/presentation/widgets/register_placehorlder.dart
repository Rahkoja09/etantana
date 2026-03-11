import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class RegisterPlaceholder extends StatelessWidget {
  final VoidCallback onRegisterTap;

  const RegisterPlaceholder({super.key, required this.onRegisterTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120.h,
              width: 120.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                HugeIcons.strokeRoundedUserAdd01,
                size: 50.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: 10.h),

            Text(
              "Rejoignez l'aventure",
              textAlign: TextAlign.center,
              style: TextStyles.titleLarge(
                context: context,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 12.h),

            Text(
              "Créez votre profil pour commencer à gérer vos boutiques, vos stocks et vos livraisons en toute simplicité.",
              textAlign: TextAlign.center,
              style: TextStyles.bodyMedium(
                context: context,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),

            SizedBox(height: 10.h),

            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: TextButton(
                onPressed: onRegisterTap,
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Créer mon profil maintenant",
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyText(
                    context: context,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
