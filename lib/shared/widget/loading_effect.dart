import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingEffect {
  static ShimmerEffect getCommonEffect(BuildContext context) {
    return ShimmerEffect(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      baseColor: Theme.of(context).colorScheme.surfaceContainer,
      highlightColor: Theme.of(
        context,
      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      duration: Duration(seconds: 3),
    );
  }
}
