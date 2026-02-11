import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart'; // Ajuste selon ton import réel
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';
import 'package:e_tantana/shared/widget/actions/swipe_action.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class MinimalDeliverieView extends StatelessWidget {
  final MapEntity delivery;
  final VoidCallback? onTap;

  const MinimalDeliverieView({super.key, required this.delivery, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(delivery.status ?? "");

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
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
              border: Border.all(
                color: colorScheme.outlineVariant.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Liv_${delivery.id}",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    _buildStatusBadge(
                      delivery.status ?? "pending",
                      statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Ligne 2 : Adresse (Grosse et grasse)
                Text(
                  delivery.location,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
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
                          style: TextStyle(
                            fontSize: 12,
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
                        fontSize: 14,
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

  // Le badge de l'image (Fond bleu clair, texte bleu foncé)
  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blueAccent;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }
}
