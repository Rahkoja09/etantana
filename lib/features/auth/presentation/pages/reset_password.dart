import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:e_tantana/shared/widget/input/Password_input.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passwordMatch = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authAtion = ref.read(authControllerProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(toolbarHeight: 10),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(StylesConstants.spacerContent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Réinitialiser\nvotre mot de passe",
                textAlign: TextAlign.left,
                style: TextStyles.titleMedium(context: context),
              ),
              SizedBox(height: 8.h),
              Text(
                "Il ne vous suffit que d'entrer un nouveau mot de passe'}",
                style: TextStyles.bodyMedium(
                  context: context,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 30),

              PasswordInput(
                textHint: "Mot de passe",
                isPassWord: false,
                textEditControlleur: passwordController,
              ),
              SizedBox(height: 15),
              PasswordInput(
                textHint: "Confirmer mot de passe",
                isPassWord: false,
                textEditControlleur: confirmPasswordController,
              ),
              if (passwordMatch == false)
                ShowInputError(
                  message: "Les deux mot de passe ne sont pas identiques",
                ),

              SizedBox(height: 25),
              Container(
                width: double.infinity,
                height: 40,
                child: Button(
                  onTap: () async {
                    if (passwordController.text.isNotEmpty &&
                        confirmPasswordController.text.isNotEmpty &&
                        passwordController.text ==
                            confirmPasswordController.text) {
                      setState(() {
                        passwordMatch = true;
                      });
                      await authAtion.changePassword(
                        confirmPasswordController.text,
                      );
                      await authAtion.logout();
                      context.go("/sign-in");
                    } else {
                      setState(() {
                        passwordMatch = false;
                      });
                    }
                  },
                  btnColor: colorScheme.primary,
                  borderRadius: StylesConstants.borderRadius,
                  btnTextColor: Colors.white,
                  btnText: "Changer mon mot de passe",
                  isLoading: authState.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
