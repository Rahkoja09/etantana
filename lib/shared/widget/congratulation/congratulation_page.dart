import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CongratulationPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? note;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Color? accentColor;

  const CongratulationPage({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
    this.note,
    this.secondaryLabel,
    this.onSecondary,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Icône
              Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36.sp, color: accent),
              ),

              SizedBox(height: 40.h),

              // Titre
              Text(
                title,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: onSurface,
                  letterSpacing: -0.6,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),

              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: onSurface.withValues(alpha: 0.45),
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              // Note optionnelle
              if (note != null) ...[
                SizedBox(height: 28.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: onSurface.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    note!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: onSurface.withValues(alpha: 0.4),
                      height: 1.55,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const Spacer(flex: 4),

              // Bouton primaire
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onPrimary,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    primaryLabel,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Bouton secondaire
              if (secondaryLabel != null && onSecondary != null) ...[
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: onSecondary,
                  child: Text(
                    secondaryLabel!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: onSurface.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
