import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/app/session/session_controller.dart';
import 'package:e_tantana/core/enums/order_status.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/cart/domain/entity/cart_entity.dart';
import 'package:e_tantana/features/cart/presentation/controller/cart_session_controller.dart';
import 'package:e_tantana/features/delivring/presentation/controller/delivering_controller.dart';
import 'package:e_tantana/features/home/presentation/controller/dashboard_controller.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/presentation/controller/order_controller.dart';
import 'package:e_tantana/features/product/presentation/controller/product_controller.dart';
import 'package:e_tantana/features/stockPrediction/presentation/controller/stock_prediction_controller.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/bottom_container_button.dart';
import 'package:e_tantana/shared/widget/input/custom_drop_down.dart';
import 'package:e_tantana/shared/widget/input/date_input.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/input/swith_selector.dart';
import 'package:e_tantana/shared/widget/loading/loading.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:e_tantana/shared/widget/others/separator_background.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:e_tantana/shared/widget/title/title_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class AddOrder extends ConsumerStatefulWidget {
  const AddOrder({super.key});

  @override
  ConsumerState<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends ConsumerState<AddOrder> {
  DeliveryStatus? selectedStatus;
  DateTime? deliveryDate;
  String deliveryCity = "Antananarivo";
  String countryCallCode = "+261";

  final TextEditingController clientName = TextEditingController();
  final TextEditingController clientTel = TextEditingController();
  final TextEditingController clientAdrs = TextEditingController();
  final TextEditingController fraisDeLiv = TextEditingController();

  String? errorCart;
  String? errorStatus;
  String? errorClientTel;
  String? errorAdrsClient;
  String? errorDeliveryCosts;
  String? errorDeliveryDate;

  bool _validateFields(List<CartEntity> carts) {
    setState(() {
      errorCart = carts.isEmpty ? "Le panier est vide" : null;
      errorStatus = selectedStatus == null ? "Le statut est obligatoire" : null;
      errorDeliveryDate =
          deliveryDate == null ? "Veuillez choisir la date de livraison" : null;
      errorClientTel =
          clientTel.text.isEmpty ? "Le numéro client est obligatoire" : null;
      errorAdrsClient =
          clientAdrs.text.isEmpty ? "L'adresse client est obligatoire" : null;
      errorDeliveryCosts =
          fraisDeLiv.text.isEmpty
              ? "Les frais de livraison sont obligatoires"
              : null;
    });
    return errorCart == null &&
        errorStatus == null &&
        errorClientTel == null &&
        errorAdrsClient == null &&
        errorDeliveryCosts == null &&
        errorDeliveryDate == null;
  }

  @override
  void dispose() {
    clientName.dispose();
    clientTel.dispose();
    clientAdrs.dispose();
    fraisDeLiv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderControllerProvider);
    final orderAction = ref.read(orderControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    final shopId = ref.watch(sessionProvider).activeShopId;
    final carts = ref.watch(cartSessionProvider).carts ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: SimpleAppbar(
        title: "Créer une commande",
        onBack: () => context.pop(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(StylesConstants.spacerContent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CartSummarySection(carts: carts),
                ShowInputError(message: errorCart),
                SizedBox(height: 10.h),

                SeparatorBackground(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleWithIcon(
                        boldTitle: true,
                        icon: Icons.shopping_bag,
                        title: "Détails de la commande",
                        themeColor: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 20.h),
                      MediumTitleWithDegree(
                        showDegree: true,
                        degree: 1,
                        title: "Statut de la commande",
                      ),
                      SwithSelector(
                        themeColor: Theme.of(context).colorScheme.primary,
                        options: DeliveryStatus.values,
                        initialValue: DeliveryStatus.pending,
                        labelBuilder: (status) => status.label,
                        onChanged:
                            (val) => setState(() => selectedStatus = val),
                      ),
                      ShowInputError(message: errorStatus),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                SeparatorBackground(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleWithIcon(
                        boldTitle: true,
                        icon: Icons.person,
                        title: "Informations client",
                        themeColor: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 20.h),
                      MediumTitleWithDegree(
                        showDegree: true,
                        degree: 1,
                        title: "Nom Client",
                      ),
                      SimpleInput(
                        textHint: "ex: Rakoto",
                        iconData: HugeIcons.strokeRoundedId,
                        textEditControlleur: clientName,
                        maxLines: 1,
                      ),
                      SizedBox(height: 20.h),
                      MediumTitleWithDegree(
                        showDegree: true,
                        degree: 1,
                        title: "N. Téléphone Client",
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomDropdown(
                              textHint: "+261",
                              iconData: HugeIcons.strokeRoundedContactBook,
                              items: ["+261", "+33", "+1"],
                              value: countryCallCode,
                              onChanged:
                                  (val) => setState(
                                    () => countryCallCode = val ?? "+261",
                                  ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            flex: 5,
                            child: SimpleInput(
                              textHint: "ex: 343032386",
                              iconData: HugeIcons.strokeRoundedCall02,
                              textEditControlleur: clientTel,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      ShowInputError(message: errorClientTel),
                      SizedBox(height: 20.h),
                      MediumTitleWithDegree(
                        showDegree: true,
                        degree: 1,
                        title: "Adresse de Livraison",
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdown(
                              value: deliveryCity,
                              textHint: "Ville",
                              iconData: HugeIcons.strokeRoundedMaps,
                              items: [
                                "Antananarivo",
                                "Fianarantsoa",
                                "Toamasina",
                                "Antsirabe",
                                "Diego",
                                "Mahajanga",
                              ],
                              onChanged:
                                  (val) => setState(
                                    () => deliveryCity = val ?? "Antananarivo",
                                  ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: SimpleInput(
                              textHint: "ex: Analakely",
                              iconData: HugeIcons.strokeRoundedMapsLocation01,
                              textEditControlleur: clientAdrs,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      ShowInputError(message: errorAdrsClient),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                SeparatorBackground(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleWithIcon(
                        boldTitle: true,
                        icon: Icons.delivery_dining_sharp,
                        title: "Logistiques",
                        themeColor: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 20.h),
                      MediumTitleWithDegree(
                        showDegree: true,
                        degree: 1,
                        title: "Frais de Livraison",
                      ),
                      SimpleInput(
                        textHint: "ex: 4000",
                        iconData: HugeIcons.strokeRoundedDeliveryTruck02,
                        textEditControlleur: fraisDeLiv,
                        maxLines: 1,
                      ),
                      ShowInputError(message: errorDeliveryCosts),
                      SizedBox(height: 20.h),
                      MediumTitleWithDegree(
                        showDegree: true,
                        degree: 1,
                        title: "Date de Livraison",
                      ),
                      DateInput(
                        iconData: HugeIcons.strokeRoundedCalendarAdd01,
                        textHint: "Date de livraison",
                        isRange: false,
                        onDateSelected:
                            (date) => setState(() => deliveryDate = date),
                      ),
                      ShowInputError(message: errorDeliveryDate),
                    ],
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
          if (orderState.isLoading) Loading(),
        ],
      ),

      bottomNavigationBar: BottomContainerButton(
        nextBtnText: "Créer la commande",
        onBack: () => context.pop(),
        onValidate: () async {
          if (!_validateFields(carts)) return;

          final productsAndQuantities =
              carts.map((e) => e.toOrderFormat()).toList();
          final totalQty = carts.fold(0, (sum, e) => sum + (e.quantity ?? 0));

          final orderData = OrderEntities(
            clientAdrs: "${deliveryCity.trim()} - ${clientAdrs.text.trim()}",
            clientName: clientName.text.trim(),
            clientTel: "$countryCallCode${clientTel.text.trim()}",
            deliveryCosts: double.tryParse(fraisDeLiv.text.trim()),
            shopId: shopId,
            userId: authState.user?.id,
            productsAndQuantities: productsAndQuantities,
            quantity: totalQty,
            status: selectedStatus,
            deliveryDate: deliveryDate,
          );

          await orderAction.placeCompleteOrder(orderData);
          ref.read(cartSessionProvider.notifier).clear();

          await Future.wait([
            ref.read(productControllerProvider.notifier).researchProduct(null),
            ref
                .read(deliveringControllerProvider.notifier)
                .searchDelivering(null),
            ref.read(stockPredictionControllerProvider.notifier).refreshHome(),
            ref
                .read(dashboardStatsControllerProvider.notifier)
                .getDashboardStats(),
          ]);

          if (mounted) context.pop();
        },
      ),
    );
  }
}

class _CartSummarySection extends StatelessWidget {
  final List<CartEntity> carts;
  const _CartSummarySection({required this.carts});

  double get _total => carts.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    if (carts.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Theme.of(context).colorScheme.error,
              size: 18.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              "Aucun produit dans le panier",
              style: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(StylesConstants.spacerContent),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        border: Border.all(color: primary.withValues(alpha: 0.15)),
        gradient: LinearGradient(
          colors: [
            primary.withValues(alpha: 0.04),
            primary.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Panier",
                style: TextStyles.bodyMedium(
                  context: context,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "${_total.toStringAsFixed(0)} Ar",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...carts.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: 36.r,
                      height: 36.r,
                      child: ImageViewer(
                        borderRadius: 6,
                        imageFileOrLink: item.productImage,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.chosenVariant != null)
                          Text(
                            _buildVariantLabel(item.chosenVariant!),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "× ${item.quantity}",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        "${item.totalPrice.toStringAsFixed(0)} Ar",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildVariantLabel(Map<String, dynamic> v) {
    final name = v['name']?.toString() ?? '';
    final property = v['property']?.toString();
    if (property != null && property != '-' && property.isNotEmpty)
      return "$name • $property";
    return name;
  }
}
