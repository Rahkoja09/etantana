import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/auth/presentation/pages/sign_up.dart';
import 'package:e_tantana/shared/widget/input/custom_swipe_button.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:e_tantana/shared/widget/others/system_overlay_task_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Bienvenue sur ${AppConst.appName}",
      "desc":
          "Gérez vos ventes et vos projets avec une simplicité déconcertante.",
    },
    {
      "title": "Suivi en temps réel",
      "desc": "Gardez un œil sur vos performances où que vous soyez.",
    },
    {
      "title": "Sécurité Maximale",
      "desc": "Vos données sont protégées par les meilleurs standards actuels.",
    },
  ];

  @override
  void initState() {
    super.initState();
    setSystemOverlay(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
      body: Stack(
        children: [
          Positioned(
            top: 20.h,
            left: -MediaQuery.of(context).size.width * 0.5,
            child: Opacity(
              opacity: 0.8,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1.1,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ImageViewer(
                  imageFileOrLink: 'assets/medias/logos/package_3D.png',
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50.h,
            right: 20.w,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SignUp()),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "passer",
                  style: TextStyles.bodyMedium(
                    context: context,
                    color: colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),

          Column(
            children: [
              const Spacer(flex: 11),
              Expanded(
                flex: 4,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(
                      () => isLastPage = index == onboardingData.length - 1,
                    );
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            onboardingData[index]["title"]!,
                            style: TextStyles.titleLarge(
                              context: context,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            onboardingData[index]["desc"]!,
                            style: TextStyles.bodyText(
                              context: context,

                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.all(30.w),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: onboardingData.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: colorScheme.primary,
                        dotColor: colorScheme.outlineVariant,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    CustomSwipeButton(
                      text:
                          isLastPage
                              ? "Commencer l'anventure"
                              : "Glisser pour continuer",
                      width: double.infinity,
                      height: 60.h,
                      backgroundColor: colorScheme.surfaceContainerLowest,
                      sliderColor: colorScheme.primary,
                      textColor: colorScheme.onSurface,
                      iconColor: Colors.white,
                      onSwipe: () {
                        if (isLastPage) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const SignUp()),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ],
      ),
    );
  }
}
