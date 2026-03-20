import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSimpleBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onTap;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color buttonColor;

  const CustomSimpleBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonLabel = "En savoir plus",
    this.onTap,
    this.gradientColors = const [Color(0xFF2D1B69), Color(0xFF1A123D)],
    this.accentColor = const Color(0xFF8B5CF6),
    this.titleColor = Colors.white,
    this.subtitleColor = const Color(0xFFEDE9FE),
    this.buttonColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Forme géométrique 1
          Positioned(
            right: -30.w,
            bottom: -30.h,
            child: CustomPaint(
              size: Size(200.w, 140.h),
              painter: _GeoPainter(
                color: accentColor.withValues(alpha: 0.3),
                points: const [
                  Offset(0.25, 0),
                  Offset(1, 0),
                  Offset(1, 1),
                  Offset(0, 1),
                ],
              ),
            ),
          ),

          // Forme géométrique 2
          Positioned(
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: Size(130.w, 80.h),
              painter: _GeoPainter(
                color: accentColor.withValues(alpha: 0.4),
                points: const [
                  Offset(0.5, 0),
                  Offset(1, 0.38),
                  Offset(1, 1),
                  Offset(0, 1),
                ],
              ),
            ),
          ),

          // Contenu
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Row(
              children: [
                // Texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                          letterSpacing: -0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: subtitleColor.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                // Bouton
                _BannerButton(
                  label: buttonLabel,
                  color: buttonColor,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _BannerButton({required this.label, required this.color, this.onTap});

  @override
  State<_BannerButton> createState() => _BannerButtonState();
}

class _BannerButtonState extends State<_BannerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder:
            (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: widget.color,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 12.sp,
                    color: widget.color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GeoPainter extends CustomPainter {
  final Color color;

  /// Points relatifs (0.0 à 1.0) du polygone
  final List<Offset> points;

  const _GeoPainter({required this.color, required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    final mapped =
        points
            .map((p) => Offset(p.dx * size.width, p.dy * size.height))
            .toList();

    path.moveTo(mapped[0].dx, mapped[0].dy);
    for (int i = 1; i < mapped.length; i++) {
      path.lineTo(mapped[i].dx, mapped[i].dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GeoPainter old) =>
      old.color != color || old.points != points;
}
