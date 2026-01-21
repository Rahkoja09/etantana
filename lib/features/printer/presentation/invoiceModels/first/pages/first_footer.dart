import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstFooter extends StatelessWidget {
  const FirstFooter({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    return Column(
      children: [
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 130,
              width: 130,
              child: Image(
                image: AssetImage('assets/medias/logos/scan_me.png'),
              ),
            ),
            Column(
              children: [
                Text(
                  "<= Facebook",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: "Nonito",
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "0380516686",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Nonito",
                    color: color,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "nmv",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontFamily: "BrunoAceSC",
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
