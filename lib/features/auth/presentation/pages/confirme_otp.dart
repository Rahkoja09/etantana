import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/auth/presentation/controller/forgot_password_controller.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:e_tantana/shared/widget/text/show_input_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfirmeOtp extends ConsumerStatefulWidget {
  const ConfirmeOtp({super.key});

  @override
  ConsumerState<ConfirmeOtp> createState() => _ConfirmeOtpState();
}

class _ConfirmeOtpState extends ConsumerState<ConfirmeOtp> {
  static const int _otpLength = 8;
  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (index) => FocusNode(),
  );
  bool valideInputs = true;

  void _handlePaste(String value, int index) {
    if (value.length > 1) {
      String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

      for (int i = 0; i < cleanValue.length && (index + i) < _otpLength; i++) {
        _controllers[index + i].text = cleanValue[i];
        if (index + i < _otpLength - 1) {
          _focusNodes[index + i + 1].requestFocus();
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((e) => e.text).join();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authAction = ref.read(authControllerProvider.notifier);
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    final forgotPasswordAction = ref.read(forgotPasswordProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: SimpleAppbar(
        onBack: () => forgotPasswordAction.previousStep(),
        title: "Vérification OTP",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(StylesConstants.spacerContent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Confirmer votre adresse email",
                style: TextStyles.titleSmall(context: context),
              ),
              SizedBox(height: 8.h),
              Text(
                "Nous avons envoyé un code à 8 chiffres à ${forgotPasswordState.email ?? 'votre email'}",
                style: TextStyles.bodyMedium(
                  context: context,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 30.h),

              //  INPUT OTP --------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (index) {
                  return SizedBox(
                    width: 35.w,
                    height: 45.h,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,

                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length > 1) {
                          _handlePaste(value, index);
                          return;
                        }

                        if (value.isNotEmpty && index < _otpLength - 1) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(_otpLength),
                      ],
                    ),
                  );
                }),
              ),

              if (!valideInputs) ...[
                SizedBox(height: 15.h),
                const ShowInputError(
                  message: "Veuillez entrer les 8 chiffres du code",
                ),
              ],

              SizedBox(height: 30.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: Button(
                  onTap: () async {
                    if (_currentOtp.length == _otpLength) {
                      setState(() => valideInputs = true);
                      await authAction.verifyOtpCode(
                        forgotPasswordState.email!,
                        _currentOtp,
                        OtpType.recovery,
                      );
                      forgotPasswordAction.setOtpCode(int.parse(_currentOtp));
                      context.go("/reset-password");
                    } else {
                      setState(() => valideInputs = false);
                    }
                  },
                  btnColor: colorScheme.primary,
                  borderRadius: StylesConstants.borderRadius,
                  btnTextColor: Colors.white,
                  btnText: "Vérifier le code",
                  isLoading: authState.isLoading,
                ),
              ),

              SizedBox(height: 25.h),

              if (forgotPasswordState.resendOtpCount <= 2)
                Align(
                  alignment: Alignment.centerRight,
                  child:
                      forgotPasswordState.timerCount > 0
                          ? Text(
                            "Nouveau code envoyé, vous pouvez réessayer dans ${forgotPasswordState.timerCount}s",
                            style: TextStyles.bodySmall(
                              context: context,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          )
                          : TextButton(
                            onPressed: () => forgotPasswordAction.resendOtp(),
                            child: Text(
                              "Renvoyer un nouveau code",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
