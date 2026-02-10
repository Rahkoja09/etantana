import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DismissibleAction {
  final String? label;
  final Color backgroundColor;
  final IconData? icon;
  final Color iconColor;
  final VoidCallback onDismiss;
  final double? iconSize;

  DismissibleAction({
    this.label,
    required this.backgroundColor,
    this.icon,
    this.iconColor = Colors.white,
    required this.onDismiss,
    this.iconSize = 28,
  });
}

class SwipeAction extends StatelessWidget {
  final Widget child;
  final DismissibleAction? leftAction;
  final DismissibleAction? rightAction;
  final Key dismissibleKey;
  final double swipeThreshold;
  final bool enableHapticFeedback;
  final Duration animationDuration;
  final DragStartBehavior dragStartBehavior;
  final EdgeInsets actionPadding;
  final BorderRadius? actionBorderRadius;

  const SwipeAction({
    super.key,
    required this.child,
    required this.dismissibleKey,
    this.leftAction,
    this.rightAction,
    this.swipeThreshold = 0.9,
    this.enableHapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.dragStartBehavior = DragStartBehavior.down,
    this.actionPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.actionBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: dismissibleKey,
      dismissThresholds: {
        if (leftAction != null) DismissDirection.startToEnd: swipeThreshold,
        if (rightAction != null) DismissDirection.endToStart: swipeThreshold,
      },
      dragStartBehavior: dragStartBehavior,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          leftAction?.onDismiss();
        } else if (direction == DismissDirection.endToStart) {
          rightAction?.onDismiss();
        }
        return false;
      },
      background:
          leftAction != null
              ? _buildSwipeActionBackground(
                action: leftAction!,
                alignment: Alignment.centerLeft,
                borderRadius: actionBorderRadius,
                padding: actionPadding,
              )
              : null,
      secondaryBackground:
          rightAction != null
              ? _buildSwipeActionBackground(
                action: rightAction!,
                alignment: Alignment.centerRight,
                borderRadius: actionBorderRadius,
                padding: actionPadding,
              )
              : null,
      child: child,
    );
  }

  Widget _buildSwipeActionBackground({
    required DismissibleAction action,
    required Alignment alignment,
    BorderRadius? borderRadius,
    required EdgeInsets padding,
  }) {
    return Container(
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(
        color: action.backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            alignment == Alignment.centerLeft
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
        children: [
          if (action.icon != null)
            Icon(action.icon, color: action.iconColor, size: action.iconSize),
          if (action.label != null) ...[
            SizedBox(height: 4),
            Text(
              action.label!,
              style: TextStyle(
                color: action.iconColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
