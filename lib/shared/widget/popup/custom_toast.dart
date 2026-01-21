import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

void showCustomToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  OverlayEntry? entry;

  entry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: 60,
        right: 0,
        child: CustomToast(
          message: message,
          onDismissed: () {
            entry?.remove();
          },
        ),
      );
    },
  );

  overlay.insert(entry);
}

class CustomToast extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const CustomToast({
    super.key,
    required this.message,
    required this.onDismissed,
  });

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _offsetAnimation;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _slideController.forward();

    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    Future.delayed(const Duration(seconds: 3), () {
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        elevation: 6,
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              width: 300.w,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.message,
                    style: TextStyles.bodyText(context: context),
                  ),
                  Expanded(child: SizedBox()),
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedInformationSquare,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 3,
                    width: 300 * (1.0 - _progressController.value),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
