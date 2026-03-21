import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/auth/presentation/controller/forgot_password_controller.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  bool valideInputs = true;

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authAction = ref.read(authControllerProvider.notifier);
    final forgotPasswordAction = ref.read(forgotPasswordProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: SimpleAppbar(onBack: () {}, title: "Mot de passe oublier"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(StylesConstants.spacerContent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mot de passe oublier ?",
                textAlign: TextAlign.left,
                style: TextStyles.titleSmall(context: context),
              ),
              SizedBox(height: 5),
              Text(
                "Pas de soucie, entrée votre adresse email et on vous enverra un code de vérification.",
                textAlign: TextAlign.left,
                style: TextStyles.bodyMedium(
                  context: context,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),

              SizedBox(height: 30),
              SimpleInput(
                textHint: "Adresse Email",
                iconData: HugeIcons.strokeRoundedMail01,
                textEditControlleur: emailController,
                maxLines: 1,
              ),
              if (valideInputs == false) ...[
                ShowInputError(
                  message: "Veuillez remplire par votre adresse email",
                ),
                SizedBox(height: 5),
              ],

              SizedBox(height: 25),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => context.go("/sign-in"),
                  child: Text(
                    "Revenir à le connexion",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "Nonito",
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),

              Container(
                width: double.infinity,
                height: 40,
                child: Button(
                  onTap: () async {
                    if (emailController.text.isNotEmpty) {
                      setState(() {
                        valideInputs = true;
                      });
                      await authAction.requestOtp(
                        emailController.text.trim().toLowerCase(),
                      );
                      forgotPasswordAction.setEmail(
                        emailController.text.trim().toLowerCase(),
                      );
                      context.go("/confirm-otp");
                    } else {
                      setState(() {
                        valideInputs = false;
                      });
                    }
                  },
                  btnColor: colorScheme.primary,
                  borderRadius: StylesConstants.borderRadius,
                  btnTextColor: Colors.white,
                  btnText: "Envoyer le code",
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
