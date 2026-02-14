import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class BigStatView extends StatefulWidget {
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
  State<BigStatView> createState() => _BigStatViewState();
}

class _BigStatViewState extends State<BigStatView> {
  bool isRecetteVisible = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 110,
          padding: EdgeInsets.all(StylesConstants.spacerContent),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.2,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.05),
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
                        child: HugeIcon(
                          icon: widget.icon,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.title,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            isRecetteVisible ? widget.value : "x,xx,xxx,xxx",
                            style: TextStyles.titleSmall(
                              context: context,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onLongPress: () {
                              setState(() {
                                isRecetteVisible = !isRecetteVisible;
                              });
                            },
                            icon: Icon(
                              isRecetteVisible
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              size: 18,
                            ),
                            onPressed: () {
                              print("nope, nothing!");
                            },
                          ),
                        ],
                      ),
                      Text(
                        widget.moneySign,
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
                children: [
                  Text(
                    widget.cycle,
                    style: TextStyles.bodyMedium(
                      context: context,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          bottom: -15,
          right: -15,
          child: Transform.rotate(
            angle: -0.25,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
        ),
      ],
    );
  }
}
