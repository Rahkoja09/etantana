import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PredictionProgressBar extends StatelessWidget {
  final double pressure;

  const PredictionProgressBar({super.key, required this.pressure});

  Color get _color {
    if (pressure > 0.8) return const Color(0xFFEF4444);
    if (pressure > 0.5) return const Color(0xFFF97316);
    return const Color(0xFF22C55E);
  }

  String get _label {
    if (pressure > 0.8) return "Critique";
    if (pressure > 0.5) return "Attention";
    return "OK";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pressure,
              minHeight: 5.h,
              backgroundColor: _color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(_color),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ),
      ],
    );
  }
}
