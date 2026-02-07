import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation {
  static Widget white({double? size}) {
    return LoadingAnimationWidget.fourRotatingDots(
      color: Colors.white,
      size: size ?? 20.w,
    );
  }

  static Widget adaptive(BuildContext context, {double? size}) {
    return LoadingAnimationWidget.fourRotatingDots(
      color: Theme.of(context).colorScheme.onSurface,
      size: size ?? 20.w,
    );
  }

  static Widget primary(BuildContext context, {double? size}) {
    return LoadingAnimationWidget.fourRotatingDots(
      color: Theme.of(context).colorScheme.primary,
      size: size ?? 30.w,
    );
  }

  static Widget dotwave(BuildContext context, {double? size}) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: Theme.of(context).colorScheme.onSurface,
      size: size ?? 30.w,
    );
  }

  static Widget jsonPersonnalisedLoading(String? jsonPath) {
    return Lottie.asset(
      jsonPath ?? 'assets/medias/animations/etantana_loading.json',
      repeat: true,
      onLoaded: (composition) {},
    );
  }
}
