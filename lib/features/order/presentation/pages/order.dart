import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/order/presentation/states/order_states.dart';
import 'package:e_tantana/features/order/presentation/widget/minimal_order_display.dart';
import 'package:e_tantana/features/printer/presentation/pages/printer_view.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:e_tantana/shared/widget/popup/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    ref.listen<OrderStates>(orderControllerProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        showToast(
          context,
          title: 'Erreur de récuperation produit.',
          isError: true,
          description: next.errorMessage!,
        );
      }
      if (next.order != null) {
        allOrder = next.order!;
      }
    });

    final skeletonData = List.generate(
      5,
      (index) => OrderEntities(
        clientName: "Chargement...",
        quantity: 1,
        createdAt: DateTime.now(),
        deliveryCosts: "1000",
      ),
    );

    final isInitialLoading = orderState.isLoading && allOrder.isEmpty;
    final displayData = isInitialLoading ? skeletonData : allOrder;

    return Scaffold(
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
                          enabled: orderState.isLoading,
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
                              // GARDER TA LOGIQUE DE SKELETON (Pagination) ----------
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (showDateHeader)
                                    _buildDateHeader(item.createdAt!, context),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: MinimalOrderDisplay(
                                      order: item,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (_) => PrinterView(
                                                  order: displayData[index],
                                                ),
                                          ),
                                        );
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
    child: Text(
      headerText,
      style: TextStyles.bodyMedium(
        context: context,
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
      ),
    ),
  );
}
