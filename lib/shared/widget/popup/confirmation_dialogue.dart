import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/shared/widget/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class ConfirmationDialogue extends StatefulWidget {
  final String title;
  final String value;
  final Color? btnColor;
  final Color? backGroundColor;
  final bool isActionDangerous;
  final IconData icon;
  final String leftButtonTitle;
  final String rightButtonTitle;
  final VoidCallback? onTapLeftBtn;
  final VoidCallback? onTapRightBtn;
  final bool isloading;

  const ConfirmationDialogue({
    super.key,
    this.title = "Déconnexion",
    this.value = "Êtes-vous sûr de vouloir vous déconnecter de cette session ?",
    this.btnColor,
    this.backGroundColor,
    this.isActionDangerous = false,
    this.leftButtonTitle = "Annuler",
    this.rightButtonTitle = "Confirmer",
    this.icon = HugeIcons.strokeRoundedLogout03,
    required this.onTapLeftBtn,
    required this.onTapRightBtn,
    this.isloading = false,
  });

  @override
  State<ConfirmationDialogue> createState() => _ConfirmationDialogueState();
}

class _ConfirmationDialogueState extends State<ConfirmationDialogue>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
        opacity: _opacityAnimation,
        child: Container(
          width: 300.w,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.backGroundColor ?? Theme.of(context).colorScheme.surface,
                widget.backGroundColor?.withValues(alpha: 0.9) ??
                    Theme.of(context).colorScheme.surfaceContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface,
              width: 0.4,
            ),
            borderRadius: BorderRadius.circular(
              StylesConstants.borderRadius * 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.shadow.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color:
                      widget.isActionDangerous
                          ? Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.2)
                          : Colors.lightGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: widget.icon,
                  color:
                      widget.isActionDangerous
                          ? Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.9)
                          : Colors.white,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                widget.title,
                style: TextStyles.titleMedium(context: context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),

                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              if (widget.isloading)
                LoadingAnimation.primary(context, size: 20.sp),
              if (!widget.isloading)
                Text(
                  widget.value,
                  style: TextStyles.bodyMedium(context: context).copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildButton(
                      context,
                      widget.btnColor ??
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      Theme.of(context).colorScheme.onSurface,
                      widget.leftButtonTitle,
                      widget.onTapLeftBtn ?? () => Navigator.pop(context),
                      false,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: _buildButton(
                      context,
                      widget.btnColor ??
                          Colors.lightGreenAccent.withValues(alpha: 0.6),
                      Colors.white,
                      widget.rightButtonTitle,
                      widget.onTapRightBtn ??
                          () {
                            Navigator.pop(context);
                          },
                      true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    Color color,
    Color? textColor,
    String title,
    VoidCallback onTap,
    bool isPrimary,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor:
            isPrimary ? Colors.white : Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        elevation: isPrimary ? 4 : 2,
      ),
      child: Text(
        title,
        style: TextStyles.buttonText(context: context).copyWith(
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}
