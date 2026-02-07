import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/shared/widget/loading/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      offsetToArmed: 60.h,
      builder: (context, child, controller) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            child,
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                if (controller.isIdle) return const SizedBox.shrink();

                return Positioned(
                  top: 20.h * controller.value,
                  child: Opacity(
                    opacity: controller.value.clamp(0.0, 1.0),
                    child: Container(
                      height: 30,
                      width: 30,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.9),
                      ),
                      child: LoadingAnimation.jsonPersonnalisedLoading(null),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
      child: child,
    );
  }
}
