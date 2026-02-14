import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/enums/order_status.dart';
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';
import 'package:e_tantana/shared/widget/actions/swipe_action.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class MinimalDeliverieView extends StatelessWidget {
  final MapEntity delivery;
  final bool isLoading;
  final VoidCallback? onTap;

  const MinimalDeliverieView({
    super.key,
    required this.delivery,
    this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = delivery.status.color;

    return SwipeAction(
      dismissibleKey: ValueKey(delivery.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  isDelivred(delivery.status)
                      ? colorScheme.surface
                      : colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
              border: Border.all(
                color:
                    isDelivred(delivery.status)
                        ? colorScheme.outlineVariant.withValues(alpha: 0.1)
                        : colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${delivery.clientName}",
                      style: TextStyles.bodyText(
                        context: context,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStatusBadge(
                      context,
                      delivery.status.label,
                      statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Text(
                  delivery.location,
                  style: TextStyle(
                    decoration:
                        isDelivred(delivery.status)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Nonito',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          DateFormat('dd/mm/yy').format(delivery.date),
                          style: TextStyles.bodySmall(
                            context: context,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Section Prix
                    Text(
                      "frais. ${NumberFormat('#,###').format(delivery.price)} Ar",
                      style: TextStyle(
                        fontFamily: 'Nonito',
                        decoration:
                            isDelivred(delivery.status)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isDelivred(DeliveryStatus status) {
    return status == DeliveryStatus.delivered;
  }

  Widget _buildStatusBadge(BuildContext context, String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyles.bodySmall(
          context: context,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
