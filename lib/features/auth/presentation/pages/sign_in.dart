import 'package:e_tantana/config/constants/client_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/auth/presentation/states/auth_states.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:e_tantana/shared/widget/button/horizontal_social_button.dart';
import 'package:e_tantana/shared/widget/input/Password_input.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/text/horizontal_divider.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  bool valideInputs = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authAction = ref.read(authControllerProvider.notifier);

    ref.listen<AuthStates>(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/nav-bar/0');
      }
    });

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
                "Se connecter à\nvotre compte",
                textAlign: TextAlign.left,
                style: TextStyles.titleMedium(context: context),
              ),

              SizedBox(height: 30),
              SimpleInput(
                textHint: "Adresse Email",
                iconData: HugeIcons.strokeRoundedMail01,
                textEditControlleur: emailController,
                maxLines: 1,
              ),

              SizedBox(height: 15),
              PasswordInput(
                textHint: "Mot de passe",
                isPassWord: false,
                textEditControlleur: passwordController,
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    context.go("/forgot-password");
                  },
                  child: Text(
                    "Mot de passe oublier",
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
              if (valideInputs == false) ...[
                ShowInputError(message: "Veuillez remplire tout les champs"),
                SizedBox(height: 5),
              ],

              Container(
                width: double.infinity,
                height: 40,
                child: Button(
                  onTap: () async {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        passwordController.text.length >= 6) {
                      setState(() {
                        valideInputs = true;
                      });
                      await authAction.loginWithEmail(
                        emailController.text.trim(),
                        passwordController.text,
                      );
                    } else {
                      setState(() {
                        valideInputs = false;
                      });
                    }
                  },
                  btnColor: colorScheme.primary,
                  borderRadius: StylesConstants.borderRadius,
                  btnTextColor: Colors.white,
                  btnText: "se connecter",
                  isLoading: authState.isLoading,
                ),
              ),

              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: HorizontalDivider(
                      height: 1,
                      width: double.infinity,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "OU",
                    style: TextStyles.bodySmall(
                      context: context,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: HorizontalDivider(
                      height: 1,
                      width: double.infinity,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              HorizontalSocialButton(
                onTap: () {
                  context.go("/sign-up");
                },
                socialIconLinkOrAsset: "assets/medias/icons/gmail.png",
                title: "Créer un compte avec Gmail",
              ),
              SizedBox(height: 15),
              HorizontalSocialButton(
                onTap: () async {
                  print("koja");
                  await authAction.loginWithGoogle(
                    webId: ClientConst.webClientID,
                    iosId: ClientConst.iosClientID,
                  );
                },
                socialIconLinkOrAsset: "assets/medias/icons/googleLogo.png",
                title: "Continuer avec Google",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
