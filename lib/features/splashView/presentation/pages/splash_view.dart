import 'package:e_tantana/features/nav_bar/presentation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 5, milliseconds: 10));
      navigatedToNavBar();
    });
  }

  void navigatedToNavBar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NavBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(60),
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Lottie.asset(
                  "assets/medias/animations/etantana_sv_black.json",
                  height: 50,
                  repeat: false,
                ),
              ),
              const Spacer(),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
