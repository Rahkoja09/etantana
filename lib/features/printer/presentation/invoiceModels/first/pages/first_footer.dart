import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstFooter extends StatelessWidget {
  final String societyName;
  final String societyPhoneNumber;
  final String societyQrCodeLinkOrderFile;
  final String societyQrCodeSendWhere;
  final String societySlogan;
  const FirstFooter({
    super.key,
    required this.societyName,
    required this.societyPhoneNumber,
    required this.societyQrCodeLinkOrderFile,
    required this.societyQrCodeSendWhere,
    required this.societySlogan,
  });

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
              child: Image(image: AssetImage(societyQrCodeLinkOrderFile)),
            ),
            Column(
              children: [
                Text(
                  "<= $societyQrCodeSendWhere",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: "Nonito",
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "$societyPhoneNumber",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Nonito",
                    color: color,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "$societyName",
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
