import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final String message;
  final IconData? icon;
  final bool isSuccess;
  final VoidCallback? onConfirm;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.isSuccess,
    this.icon,
    this.onConfirm,
  });

  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
              width: 0.1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(StylesConstants.spacerContent),
                  decoration: BoxDecoration(
                    color:
                        widget.isSuccess
                            ? Theme.of(context).colorScheme.primary
                            : Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(StylesConstants.borderRadius),
                      topRight: Radius.circular(StylesConstants.borderRadius),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        widget.icon ??
                            (widget.isSuccess
                                ? HugeIcons.strokeRoundedCheckmarkSquare04
                                : HugeIcons.strokeRoundedCancelSquare),
                        color: Colors.white,
                        size: 40.w,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.title,
                        style: TextStyles.titleSmall(
                          context: context,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(StylesConstants.spacerContent),
                  child: Column(
                    children: [
                      Text(
                        widget.message,
                        style: TextStyles.bodyText(context: context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          widget.onConfirm?.call();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'OK',
                          style: TextStyles.bodyMedium(
                            context: context,
                            color: Colors.white,
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
      ),
    );
  }
}

// Dialogues spécifiques pour succès et erreur
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final IconData? icon;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.onConfirm,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      isSuccess: true,
      onConfirm: onConfirm,
      icon: icon,
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final IconData? icon;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.onConfirm,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      isSuccess: false,
      onConfirm: onConfirm,
      icon: icon,
    );
  }
}
