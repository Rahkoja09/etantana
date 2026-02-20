import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/enums/order_status.dart';
import 'package:e_tantana/features/delivring/presentation/controller/delivering_controller.dart';
import 'package:e_tantana/features/home/presentation/controller/dashboard_controller.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/order/presentation/states/order_states.dart';
import 'package:e_tantana/features/order/presentation/widget/minimal_order_display.dart';
import 'package:e_tantana/features/printer/presentation/pages/printer_view.dart';
import 'package:e_tantana/features/printer/presentation/providers/interaction_invoice_data_provider.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/product/presentation/states/product_state.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:e_tantana/shared/widget/input/custom_drop_down.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_animation.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/confirmation_dialogue.dart';
import 'package:e_tantana/shared/widget/popup/show_custom_popup.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:e_tantana/shared/widget/popup/transparent_background_pop_up.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Order extends ConsumerStatefulWidget {
  const Order({super.key});

  @override
  ConsumerState<Order> createState() => _OrderState();
}

class _OrderState extends ConsumerState<Order> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<OrderEntities> allOrder = [];
  bool isFetching = false;
  OrderEntities? selectionForActionOrder;

  // orders swipe actions ---------
  bool leftActionOrder = false;
  bool rightActionOrder = false;

  // status update -------------
  String newStatus = "validated";
  List<String> statusList = [
    DeliveryStatus.validated.label,
    DeliveryStatus.delivered.label,
    DeliveryStatus.pending.label,
    DeliveryStatus.cancelled.label,
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getOrder();
    });
  }

  Future<void> _onScroll() async {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (!ref.read(orderControllerProvider).isLoading) {
        setState(() {
          isFetching = true;
        });
        await ref.read(orderControllerProvider.notifier).loadNextPage();
        setState(() {
          isFetching = false;
        });
      }
    }
  }

  Future<void> _getOrder() async {
    await ref.read(orderControllerProvider.notifier).researchOrder(null);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderControllerProvider);
    final productState = ref.watch(productControllerProvider);
    final orderAction = ref.read(orderControllerProvider.notifier);
    final deilveryAction = ref.read(deliveringControllerProvider.notifier);
    final productAction = ref.read(productControllerProvider.notifier);
    final dashBoardAction = ref.read(dashboardStatsControllerProvider.notifier);

    // list des produits principales -------
    allOrder = orderState.order ?? [];

    final skeletonData = List.generate(
      5,
      (index) => OrderEntities(
        clientName: "Chargement...",
        quantity: 1,
        createdAt: DateTime.now(),
        deliveryCosts: 1000.0,
        status: DeliveryStatus.pending,
      ),
    );

    final isInitialLoading = orderState.isLoading && allOrder.isEmpty;
    final displayData = isInitialLoading ? skeletonData : allOrder;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(StylesConstants.spacerContent),
                  child: FloatingSearchBar(
                    controller: _searchController,
                    hintText: "Rechercher une commande",
                    onChanged: (value) {
                      ref
                          .read(orderControllerProvider.notifier)
                          .researchOrder(OrderEntities(clientName: value));
                    },
                    onSortTap: () {},
                  ),
                ),
                Expanded(
                  child: AppRefreshIndicator(
                    onRefresh: _getOrder,
                    child:
                        (displayData.isEmpty && !orderState.isLoading)
                            ? _buildEmptyState()
                            : Skeletonizer(
                              enabled:
                                  orderState.isLoading ||
                                  productState.isLoading,
                              effect: LoadingEffect.getCommonEffect(context),
                              justifyMultiLineText: true,
                              ignoreContainers: true,
                              child: ListView.builder(
                                controller:
                                    isInitialLoading ? null : _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: StylesConstants.spacerContent,
                                ),
                                itemCount:
                                    displayData.length +
                                    (orderState.isLoading && allOrder.isNotEmpty
                                        ? 1
                                        : 0),
                                itemBuilder: (context, index) {
                                  if (index == displayData.length - 1 &&
                                      isFetching) {
                                    return Skeletonizer(
                                      enabled: true,
                                      effect: LoadingEffect.getCommonEffect(
                                        context,
                                      ),
                                      child: MinimalOrderDisplay(
                                        order: skeletonData[0],
                                        onTap: () {},
                                        swipeAction: (String value) {},
                                      ),
                                    );
                                  }

                                  if (index >= displayData.length) {
                                    return const SizedBox.shrink();
                                  }

                                  final item = displayData[index];

                                  bool showDateHeader = false;

                                  if (index == 0) {
                                    showDateHeader = true;
                                  } else {
                                    final prevItem = displayData[index - 1];

                                    final dateCurrent = DateTime(
                                      item.createdAt!.year,
                                      item.createdAt!.month,
                                      item.createdAt!.day,
                                    );
                                    final datePrev = DateTime(
                                      prevItem.createdAt!.year,
                                      prevItem.createdAt!.month,
                                      prevItem.createdAt!.day,
                                    );

                                    if (dateCurrent != datePrev) {
                                      showDateHeader = true;
                                    }
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (showDateHeader)
                                        _buildDateHeader(
                                          item.createdAt!,
                                          context,
                                        ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: MinimalOrderDisplay(
                                          order: item,
                                          onTap: () {
                                            print(item);
                                            ref
                                                .read(
                                                  interactionInvoiceDataNotifierProvider
                                                      .notifier,
                                                )
                                                .initOrder(item);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => PrinterView(
                                                      order: displayData[index],
                                                    ),
                                              ),
                                            );
                                          },
                                          swipeAction: (value) {
                                            if (value == "leftSwipeOrder") {
                                              print("test");
                                              setState(() {
                                                leftActionOrder = true;
                                                selectionForActionOrder = item;
                                              });
                                            } else if (value ==
                                                "rightSwipeOrder") {
                                              if (item.status !=
                                                  DeliveryStatus.cancelled) {
                                                showCustomPopup(
                                                  context: context,
                                                  description:
                                                      "Le status definie l'état actuel de la commande",
                                                  isError: false,
                                                  title: "Modifier le status",
                                                  dismissible: true,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (orderState.isLoading)
                                                        LoadingAnimation.primary(
                                                          context,
                                                          size: 30,
                                                        ),
                                                      if (!orderState.isLoading)
                                                        MediumTitleWithDegree(
                                                          showDegree: false,
                                                          title:
                                                              "Status de la commande",
                                                        ),
                                                      CustomDropdown(
                                                        textHint:
                                                            "Chosir le nouveau status",

                                                        iconData:
                                                            HugeIcons
                                                                .strokeRoundedCheckList,
                                                        items: statusList,
                                                        onChanged: (status) {
                                                          setState(() {
                                                            newStatus = status!;
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(height: 30),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Button(
                                                            onTap:
                                                                () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                            enableNoBackground:
                                                                true,
                                                            btnColor:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                            btnText: "Annuler",
                                                            btnTextColor:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                          ),
                                                          Button(
                                                            onTap: () async {
                                                              final navigator =
                                                                  Navigator.of(
                                                                    context,
                                                                  );
                                                              final update =
                                                                  item.copyWith(
                                                                    status: DeliveryStatus
                                                                        .values
                                                                        .byName(
                                                                          newStatus,
                                                                        ),
                                                                  );
                                                              await orderAction
                                                                  .updateOrderFlow(
                                                                    update,
                                                                  );
                                                              if (newStatus ==
                                                                  DeliveryStatus
                                                                      .cancelled
                                                                      .name) {
                                                                await productAction
                                                                    .cancelAndRestock(
                                                                      item.id!,
                                                                    );
                                                              }
                                                              await _getOrder();
                                                              await deilveryAction
                                                                  .searchDelivering(
                                                                    null,
                                                                  );
                                                              await dashBoardAction
                                                                  .getDashboardStats();
                                                              navigator.pop();
                                                            },
                                                            btnColor:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                            btnText: "Valider",
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
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
        ),
        if (leftActionOrder)
          TransparentBackgroundPopUp(
            widget: ConfirmationDialogue(
              backGroundColor: Theme.of(context).colorScheme.surface,
              btnColor: null,
              isActionDangerous: true,
              title: "Vouler vous vraiment supprimer commande :",
              value:
                  "${selectionForActionOrder!.clientName}\n${selectionForActionOrder!.createdAt}",
              icon: HugeIcons.strokeRoundedDelete03,
              isloading: orderState.isLoading,
              onTapLeftBtn: () async {
                setState(() {
                  leftActionOrder = false;
                });
              },
              onTapRightBtn: () async {
                await ref
                    .read(orderControllerProvider.notifier)
                    .deleteOrderById(selectionForActionOrder!.id!);
                await _getOrder();

                setState(() {
                  leftActionOrder = false;
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 60.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            const Text("Aucune commande trouvée"),
          ],
        ),
      ),
    );
  }
}

Widget _buildDateHeader(DateTime date, BuildContext context) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final dateToCheck = DateTime(date.year, date.month, date.day);

  String headerText;

  if (dateToCheck == today) {
    headerText = "Aujourd'hui";
  } else if (dateToCheck == yesterday) {
    headerText = "Hier";
  } else {
    headerText =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  return Padding(
    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Mes commandes",
          style: TextStyles.bodyMedium(
            context: context,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Text(
              "---- $headerText",
              style: TextStyles.bodyMedium(
                context: context,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar01,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
              size: 15,
            ),
          ],
        ),
      ],
    ),
  );
}
