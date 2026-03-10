import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrlOrAssets;
  const CustomAvatar({super.key, this.imageUrlOrAssets});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: 40.w,
      child: ImageViewer(imageFileOrLink: imageUrlOrAssets, borderRadius: 40),
    );
  }
}
