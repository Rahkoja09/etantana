import 'package:flutter/material.dart';

Route animatedRoute1(Widget nextPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      );
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );

      return SlideTransition(
        position: offsetTween.animate(curvedAnimation),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}

Route animatedRoute2(Widget nextPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scaleTween = Tween<double>(begin: 0.0, end: 1.0);
      final rotationTween = Tween<double>(begin: -0.2, end: 0.0);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );

      return ScaleTransition(
        scale: scaleTween.animate(curvedAnimation),
        child: RotationTransition(
          turns: rotationTween.animate(curvedAnimation),
          child: FadeTransition(opacity: animation, child: child),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 600),
  );
}

Route animatedRoute3(Widget nextPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final leftOffsetTween = Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: const Offset(-0.5, 0.0),
      );
      final rightOffsetTween = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: const Offset(0.5, 0.0),
      );
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic, // Transition fluide
      );

      return Stack(
        children: [
          SlideTransition(
            position: leftOffsetTween.animate(curvedAnimation),
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: 0.5,
                child: FadeTransition(opacity: animation, child: child),
              ),
            ),
          ),
          SlideTransition(
            position: rightOffsetTween.animate(curvedAnimation),
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerRight,
                widthFactor: 0.5,
                child: FadeTransition(opacity: animation, child: child),
              ),
            ),
          ),
        ],
      );
    },
    transitionDuration: const Duration(milliseconds: 700),
  );
}

Route animatedRoute4(Widget nextPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      );
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.bounceOut,
      );

      return SlideTransition(
        position: offsetTween.animate(curvedAnimation),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 600),
  );
}
