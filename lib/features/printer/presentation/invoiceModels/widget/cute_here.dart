import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CuteHere extends StatelessWidget {
  const CuteHere({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h),
        child: Text(
          "✂ - - - - - - - - - - - - - - - - - - - - -",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
