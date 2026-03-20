import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuardPopup {
  static void show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    String dismissLabel = "Plus tard",
  }) {
    showDialog(
      context: context,
      barrierColor: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.4),
      barrierDismissible: true,
      builder:
          (_) => _GuardPopupCard(
            icon: icon,
            title: title,
            message: message,
            actionLabel: actionLabel,
            onAction: () {
              Navigator.pop(context);
              onAction();
            },
            dismissLabel: dismissLabel,
            onDismiss: () => Navigator.pop(context),
          ),
    );
  }
}

class _GuardPopupCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final String dismissLabel;
  final VoidCallback onAction;
  final VoidCallback onDismiss;

  const _GuardPopupCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.dismissLabel,
    required this.onAction,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(28.r),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 26.sp, color: primary),
                ),
                SizedBox(height: 22.h),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: onSurface,
                    letterSpacing: -0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),

                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: onSurface.withValues(alpha: 0.45),
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 28.h),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onAction,
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      actionLabel,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                TextButton(
                  onPressed: onDismiss,
                  child: Text(
                    dismissLabel,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: onSurface.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
