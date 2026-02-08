import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class BigStatView extends StatelessWidget {
  final String title;
  final String cycle;

  final IconData icon;
  final String value;
  final String moneySign;
  final String increasePercent;
  const BigStatView({
    super.key,
    required this.title,
    required this.cycle,
    required this.icon,
    required this.value,
    required this.moneySign,
    required this.increasePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: EdgeInsets.all(StylesConstants.spacerContent),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.2,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        StylesConstants.borderRadius,
                      ),
                    ),
                    child: HugeIcon(icon: icon, color: Colors.white, size: 15),
                  ),
                  SizedBox(width: 5),
                  Text(
                    title,
                    style: TextStyles.bodyMedium(
                      context: context,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyles.titleSmall(
                      context: context,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    moneySign,
                    style: TextStyles.bodySmall(
                      context: context,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                cycle,
                style: TextStyles.bodyMedium(
                  context: context,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  increasePercent,
                  style: TextStyles.bodyMedium(
                    context: context,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
