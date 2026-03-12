import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class StockPredictionBannerCard extends StatelessWidget {
  final VoidCallback onTap;
  final int criticalCount;
  final int totalProducts;

  const StockPredictionBannerCard({
    super.key,
    required this.onTap,
    this.criticalCount = 0,
    this.totalProducts = 0,
  });

  bool get _hasAlert => criticalCount > 0;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110.h,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Cercles décoratifs fond
            Positioned(
              right: -30.w,
              top: -30.h,
              child: _buildCircle(120.r, primary, 0.15),
            ),
            Positioned(
              right: 40.w,
              bottom: -40.h,
              child: _buildCircle(100.r, primary, 0.1),
            ),
            Positioned(
              right: -10.w,
              bottom: -10.h,
              child: _buildCircle(80.r, primary, 0.2),
            ),

            // Grille de points décorative
            Positioned(right: 16.w, top: 16.h, child: _buildDotGrid()),

            // Contenu
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              child: Row(
                children: [
                  // Texte gauche
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badge IA
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                size: 9.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "INTELLIGENCE ARTIFICIELLE",
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),

                        Text(
                          _hasAlert
                              ? "$criticalCount produit${criticalCount > 1 ? 's' : ''}\nen rupture imminente"
                              : "Anticipez vos\nruptures de stock",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // CTA
                        Row(
                          children: [
                            Text(
                              "Voir l'analyse",
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 11.sp,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Icone droite
                  _buildRightIcon(context),
                ],
              ),
            ),

            // Point alerte rouge si critique
            if (_hasAlert)
              Positioned(
                top: 14.h,
                right: 14.w,
                child: Container(
                  width: 10.r,
                  height: 10.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: opacity),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildDotGrid() {
    return SizedBox(
      width: 60.w,
      height: 60.h,
      child: CustomPaint(painter: _DotGridPainter()),
    );
  }

  Widget _buildRightIcon(BuildContext context) {
    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 28.sp,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          Icon(Icons.auto_awesome_rounded, size: 16.sp, color: Colors.white),
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..style = PaintingStyle.fill;

    const spacing = 10.0;
    const dotRadius = 1.5;

    for (double x = 0; x <= size.width; x += spacing) {
      for (double y = 0; y <= size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
