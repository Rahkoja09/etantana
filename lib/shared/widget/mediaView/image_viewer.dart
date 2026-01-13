import 'package:e_tantana/core/utils/tools/isUrl.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final dynamic imageFileOrLink;
  const ImageViewer({super.key, required this.imageFileOrLink});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child:
            isUrl(imageFileOrLink)
                ? Image.network(imageFileOrLink, fit: BoxFit.cover)
                : Image.asset(imageFileOrLink!, fit: BoxFit.cover),
      ),
    );
  }
}
