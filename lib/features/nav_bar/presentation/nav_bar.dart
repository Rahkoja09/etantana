import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/appBar/presentation/app_bar_custom.dart';
import 'package:e_tantana/features/nav_bar/presentation/exemple.dart';
import 'package:e_tantana/features/order/presentation/pages/add_order.dart';
import 'package:e_tantana/features/order/presentation/pages/order.dart';
import 'package:e_tantana/features/product/presentation/pages/add_product.dart';
import 'package:e_tantana/features/product/presentation/pages/product.dart';
import 'package:e_tantana/shared/widget/selectableOption/moderne_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class NavBar extends ConsumerStatefulWidget {
  final int selectedIndex;
  const NavBar({super.key, this.selectedIndex = 0});

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> with TickerProviderStateMixin {
  late int _bottomNavIndex;
  late AnimationController _hideBottomBarAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> fabAnimation;

  @override
  void initState() {
    super.initState();

    _bottomNavIndex = widget.selectedIndex;

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    _fabAnimationController.forward();
  }

  final List<IconData> _iconList = [
    HugeIcons.strokeRoundedPackage,
    HugeIcons.strokeRoundedShoppingBasketCheckIn01,
    HugeIcons.strokeRoundedDeliveryTruck01,
    HugeIcons.strokeRoundedInvoice03,
  ];

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      if (notification.direction == ScrollDirection.reverse) {
        _hideBottomBarAnimationController.forward();
        _fabAnimationController.reverse();
      } else if (notification.direction == ScrollDirection.forward) {
        _hideBottomBarAnimationController.reverse();
        _fabAnimationController.forward();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          extendBody: true,
          appBar: const AppBarCustom(),
          //endDrawer: const SideBar(),

          // IndexedStack save state of pages ----------
          body: NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: IndexedStack(
              index: _bottomNavIndex,
              children: const [Product(), Order(), Exemple(), Exemple()],
            ),
          ),

          floatingActionButton: ScaleTransition(
            scale: fabAnimation,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                HugeIcons.strokeRoundedAdd01,
                color: Colors.white,
              ),
              onPressed: () {
                _showEditOptionsDialog(context);
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            borderColor: Theme.of(context).colorScheme.surfaceContainer,
            itemCount: _iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color =
                  isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant;

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_iconList[index], size: 20.w, color: color),
                  SizedBox(height: 2.h),
                  Text(
                    _getLabel(index),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
            backgroundColor: Theme.of(context).colorScheme.surface,
            activeIndex: _bottomNavIndex,
            splashColor: Theme.of(context).colorScheme.primary,
            notchSmoothness: NotchSmoothness.softEdge,
            gapLocation: GapLocation.center,
            onTap: (index) => setState(() => _bottomNavIndex = index),
            hideAnimationController: _hideBottomBarAnimationController,
          ),
        ),
      ],
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return "Produit";
      case 1:
        return "Commande";
      case 2:
        return "Livraison";
      case 3:
        return "Impression";
      default:
        return "Produit";
    }
  }

  @override
  void dispose() {
    _hideBottomBarAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }
}

void _showEditOptionsDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder:
        (sheetContext) => Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(StylesConstants.borderRadius * 2),
              topRight: Radius.circular(StylesConstants.borderRadius * 2),
            ),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.2),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Ajout produit ou commande',
                  style: TextStyles.titleSmall(
                    context: context,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24.h),
                ModerneOptionCard(
                  context: context,
                  icon: HugeIcons.strokeRoundedGarage,
                  title: 'En Stock',
                  subtitle: 'Le produit est déjà en arrivé',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => AddProduct()));
                  },
                  isActive: true,
                ),
                SizedBox(height: 12.h),
                ModerneOptionCard(
                  context: context,
                  icon: HugeIcons.strokeRoundedPackageMoving,
                  title: 'Future Stock',
                  subtitle: 'Le produit est encore en transit',
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                  isActive: true,
                ),
                SizedBox(height: 12.h),
                ModerneOptionCard(
                  context: context,
                  icon: HugeIcons.strokeRoundedInvoice03,
                  title: 'Commande',
                  subtitle: 'Passer la commande d\'un Client',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const AddOrder()));
                  },
                  isActive: true,
                ),
                SizedBox(height: 12.h),
                ModerneOptionCard(
                  context: context,
                  icon: HugeIcons.strokeRoundedDeliveryTruck01,
                  title: 'Livraison',
                  subtitle: 'Assigné un nouveau frais de Livraison à un lieu',
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                  isActive: true,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
  );
}
