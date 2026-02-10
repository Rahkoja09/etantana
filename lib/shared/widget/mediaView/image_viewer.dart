import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_tantana/core/utils/tools/isUrl.dart';
import 'package:e_tantana/shared/widget/loading/loading_animation.dart';
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
                ? CachedNetworkImage(
                  imageUrl: imageFileOrLink,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: Theme.of(context).colorScheme.onSurface,
                        child: LoadingAnimation.adaptive(context),
                      ),
                  errorWidget:
                      (context, url, error) => const Icon(Icons.broken_image),
                )
                : Image.asset(imageFileOrLink!, fit: BoxFit.cover),
      ),
    );
  }
}
