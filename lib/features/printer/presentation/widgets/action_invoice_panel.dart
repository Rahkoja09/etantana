import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionInvoicePanel extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPrint;
  final VoidCallback onSave;
  final VoidCallback onChooseModel;

  const ActionInvoicePanel({
    super.key,
    required this.isLoading,
    required this.onPrint,
    required this.onSave,
    required this.onChooseModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.black54),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: isLoading ? 0.3 : 1.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.print_rounded,
                  label: "Imprimer",
                  color: Colors.blueAccent,
                  onTap: isLoading ? null : onPrint,
                ),
                _buildActionButton(
                  icon: Icons.save_alt_rounded,
                  label: "Enregistrer",
                  color: Colors.green,
                  onTap: isLoading ? null : onSave,
                ),
                _buildActionButton(
                  icon: Icons.edit,
                  label: "Modifier",
                  color: Colors.orangeAccent,
                  onTap: isLoading ? null : onChooseModel,
                ),
              ],
            ),
          ),

          if (isLoading)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Traitement...",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28.sp),
          ),
        ],
      ),
    );
  }
}
