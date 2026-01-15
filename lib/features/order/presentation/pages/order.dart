import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/order/presentation/states/order_states.dart';
import 'package:e_tantana/features/order/presentation/widget/minimal_order_display.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Order extends ConsumerStatefulWidget {
  const Order({super.key});

  @override
  ConsumerState<Order> createState() => _OrderState();
}

TextEditingController searchInput = TextEditingController();

class _OrderState extends ConsumerState<Order> {
  List<OrderEntities> allOrder = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getOrder();
    });
  }

  Future<void> _getOrder() async {
    await ref.read(orderControllerProvider.notifier).researchOrder(null);
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderControllerProvider);
    final displayData =
        orderState.isLoading
            ? List.generate(
              10,
              (index) => OrderEntities(
                clientName: "Chargement...",
                quantity: 1,
                createdAt: DateTime(2000, 12, 12),
                deliveryCosts: "1000",
              ),
            )
            : allOrder;

    ref.listen<OrderStates>(orderControllerProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        showDialog(
          context: context,
          builder:
              (context) => ErrorDialog(
                title: "Erreur de récuperation commande.",
                message: next.errorMessage!,
              ),
        );
      }
      if (next.order != null && next.isLoading == false) {
        allOrder = next.order!;
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: StylesConstants.spacerContent,
                right: StylesConstants.spacerContent,
                top: StylesConstants.spacerContent,
              ),
              child: FloatingSearchBar(
                controller: searchInput,
                hintText: "Rechercher une commande",
                onChanged: (value) {},
                onSortTap: () {},
              ),
            ),

            Expanded(
              child: AppRefreshIndicator(
                onRefresh: () async {
                  await _getOrder();
                },
                child: Skeletonizer(
                  effect: LoadingEffect.getCommonEffect(context),
                  ignoreContainers: true,
                  justifyMultiLineText: true,
                  enableSwitchAnimation: true,
                  enabled: orderState.isLoading,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(StylesConstants.spacerContent),
                    itemCount: displayData.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          MinimalOrderDisplay(order: displayData[index]),
                          SizedBox(height: 8.h),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
