import 'package:e_tantana/shared/widget/actions/swipe_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:hugeicons/hugeicons.dart';

class MinimalOrderDisplay extends StatefulWidget {
  final OrderEntities order;
  final ValueChanged<String> swipeAction;
  final VoidCallback onTap;
  const MinimalOrderDisplay({
    super.key,
    required this.order,
    required this.swipeAction,
    required this.onTap,
  });

  @override
  State<MinimalOrderDisplay> createState() => _MinimalOrderDisplayState();
}

class _MinimalOrderDisplayState extends State<MinimalOrderDisplay> {
  final borderRadius = BorderRadius.circular(10);
  @override
  Widget build(BuildContext context) {
    double calculateTotal() {
      double total = 0.0;
      if (widget.order.productsAndQuantities != null) {
        for (int i = 0; i < widget.order.productsAndQuantities!.length; i++) {
          total +=
              widget.order.productsAndQuantities![i]["unit_price"] *
              widget.order.productsAndQuantities![i]["quantity"];
        }
      }
      return total;
    }

    MaterialColor getStatusColor(String status) {
      MaterialColor statusColors;
      switch (status) {
        case ("Validée"):
          {
            statusColors = Colors.green;
            break;
          }
        case ("Livrée"):
          {
            statusColors = Colors.blue;
            break;
          }
        case ("Annulée"):
          {
            statusColors = Colors.red;
            break;
          }
        case ("En Attente de Val."):
          {
            statusColors = Colors.grey;
            break;
          }
        default:
          {
            statusColors = Colors.green;
          }
      }
      return statusColors;
    }

    return SwipeAction(
      dismissibleKey: Key(widget.order.id ?? ""),
      actionBorderRadius: borderRadius,
      leftAction: DismissibleAction(
        backgroundColor: Colors.red.shade400,
        icon: HugeIcons.strokeRoundedDelete02,
        onDismiss: () {
          setState(() {
            widget.swipeAction.call("leftSwipeOrder");
          });
        },
      ),
      rightAction: DismissibleAction(
        backgroundColor: Colors.green.shade400,
        icon: HugeIcons.strokeRoundedEdit04,
        onDismiss: () {
          setState(() {
            widget.swipeAction.call("rightSwipeOrder");
          });
        },
      ),

      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.2),
              width: 0.2,
            ),
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainer.withValues(alpha: 0.3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: getStatusColor(widget.order.status ?? ""),
                  borderRadius: BorderRadius.circular(
                    StylesConstants.borderRadius + 10,
                  ),
                ),
                child: Text(
                  widget.order.status.toString(),
                  style: TextStyles.bodySmall(
                    context: context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "${widget.order.clientName.toString().toUpperCase()} (${widget.order.clientTel.toString()})",
                style: TextStyles.bodyMedium(
                  context: context,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.order.productsAndQuantities?.length == 1) ...[
                      Text(
                        "${widget.order.productsAndQuantities![0]["product_name"].toString()} x ${widget.order.quantity.toString()}",
                        style: TextStyles.bodyMedium(
                          context: context,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                    if (widget.order.productsAndQuantities != null &&
                        widget.order.productsAndQuantities!.length > 1) ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.order.productsAndQuantities?.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text(
                                "-> ${widget.order.productsAndQuantities![index]["product_name"].toString()} x ${widget.order.productsAndQuantities![index]["quantity"]}",
                                style: TextStyles.bodyMedium(
                                  context: context,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                    Text(
                      "Liv: ${widget.order.clientAdrs} (${widget.order.deliveryCosts.toString()} Ar)",
                      style: TextStyles.bodyText(
                        context: context,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Total: ",
                          style: TextStyles.bodyMedium(
                            context: context,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          "Ar ${calculateTotal()} ",
                          style: TextStyles.bodyMedium(
                            context: context,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: widget.onTap,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(
                            StylesConstants.borderRadius,
                          ),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 0.7,
                          ),
                        ),
                        child: Text(
                          "Facturer",
                          style: TextStyles.bodySmall(
                            context: context,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
