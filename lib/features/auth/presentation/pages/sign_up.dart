import 'package:e_tantana/config/constants/client_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/auth/presentation/pages/sign_in.dart';
import 'package:e_tantana/features/auth/presentation/states/auth_states.dart';
import 'package:e_tantana/features/nav_bar/presentation/nav_bar.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:e_tantana/shared/widget/button/horizontal_social_button.dart';
import 'package:e_tantana/shared/widget/input/Password_input.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/others/system_overlay_task_bar.dart';
import 'package:e_tantana/shared/widget/text/horizontal_divider.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordMatch = true;
  @override
  void initState() {
    super.initState();
    setSystemOverlay(context);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authAction = ref.read(authControllerProvider.notifier);

    ref.listen<AuthStates>(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavBar()),
        );
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
                "Créer un\nnouveau compte",
                textAlign: TextAlign.left,
                style: TextStyles.titleMedium(context: context),
              ),

              SizedBox(height: 40),
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
                      await authAction.registerWithEmail(
                        emailController.text.trim().toLowerCase(),
                        confirmPasswordController.text,
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignIn()),
                      );
                    } else {
                      setState(() {
                        passwordMatch = false;
                      });
                    }
                  },
                  btnColor: colorScheme.primary,
                  borderRadius: StylesConstants.borderRadius,
                  btnTextColor: Colors.white,
                  btnText: "Créer mon compte",
                  isLoading: authState.isLoading,
                ),
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignIn()),
                    );
                  },
                  child: Text(
                    "Déjà un compte? Se connecter",
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
                onTap: () async {
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
