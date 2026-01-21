import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/home/presentation/widgets/activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class RecentActivitySection extends ConsumerStatefulWidget {
  const RecentActivitySection({super.key});

  @override
  ConsumerState<RecentActivitySection> createState() =>
      _RecentActivitySectionState();
}

class _RecentActivitySectionState extends ConsumerState<RecentActivitySection> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'icon': HugeIcons.strokeRoundedCheckmarkCircle02,
        'title': 'Commande complétée',
        'subtitle': 'Commande #2024-001',
        'time': 'Il y a 2h',
        'color': Colors.green.shade400,
      },
      {
        'icon': HugeIcons.strokeRoundedAlertCircle,
        'title': 'Stock faible',
        'subtitle': 'Produit: Chemise Bleu (12 unités)',
        'time': 'Il y a 4h',
        'color': Colors.amber.shade400,
      },
      {
        'icon': HugeIcons.strokeRoundedUser,
        'title': 'Nouveau client',
        'subtitle': 'Jean Dupont',
        'time': 'Il y a 1 jour',
        'color': Theme.of(context).colorScheme.primary,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Activité récente",
              style: TextStyles.bodyText(
                context: context,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Voir tout",
                style: TextStyles.bodyText(
                  context: context,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 120.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: ActivityCard(
                  icon: activity['icon'] as IconData,
                  title: activity['title'] as String,
                  subtitle: activity['subtitle'] as String,
                  time: activity['time'] as String,
                  color: activity['color'] as Color,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              activities.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
