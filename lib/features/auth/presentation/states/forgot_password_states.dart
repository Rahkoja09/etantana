import 'package:equatable/equatable.dart';

class ForgotPasswordStates extends Equatable {
  final bool isForgotPassword;
  final int stepIndex;
  final String? email;
  final int? otpCode;
  final int resendOtpCount;
  final int timerCount;

  ForgotPasswordStates({
    this.isForgotPassword = false,
    this.stepIndex = 0,
    this.email,
    this.otpCode,
    this.resendOtpCount = 0,
    this.timerCount = 0,
  });

  ForgotPasswordStates copyWith({
    bool? isForgotPassword,
    int? stepIndex,
    String? email,
    int? otpCode,
    int? resendOtpCount,
    int? timerCount,
  }) {
    return ForgotPasswordStates(
      isForgotPassword: isForgotPassword ?? this.isForgotPassword,
      stepIndex: stepIndex ?? this.stepIndex,
      email: email ?? this.email,
      otpCode: otpCode ?? this.otpCode,
      resendOtpCount: resendOtpCount ?? this.resendOtpCount,
      timerCount: timerCount ?? this.timerCount,
    );
  }

  @override
  List<Object?> get props => [
    isForgotPassword,
    stepIndex,
    email,
    otpCode,
    resendOtpCount,
    timerCount,
  ];
}
