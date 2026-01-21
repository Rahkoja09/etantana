import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeHeader extends StatefulWidget {
  const WelcomeHeader({super.key});

  @override
  State<WelcomeHeader> createState() => _WelcomeHeaderState();
}

class _WelcomeHeaderState extends State<WelcomeHeader>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;

  final List<String> motivations = [
    "Matoky anao fona aho",
    "Misaina amin'ny saina fa tsy fo",
    "Ho be ny varotra zao androany",
    "Hitanao fa vitanao ilay izy",
    "Mahaiza mikajy tsara sao maty antoka",
    "Matokisa tena fa t6 tsy vitanao zany",
    "Aza adino ny maka aina kely",
    "Mba matotra rehefa manao zvtr",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    );
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bonjour Malala",
          style: TextStyles.bodyText(
            context: context,
            fontWeight: FontWeight.w300,
            fontSize: 14.sp,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withOpacity(0.08),
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: SizedBox(
            height: 50.h,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                _startAutoScroll();
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        motivations[index % motivations.length],
                        style: TextStyles.bodyText(
                          context: context,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
