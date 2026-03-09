import 'dart:async';

import 'package:e_tantana/features/auth/presentation/states/forgot_password_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordController extends StateNotifier<ForgotPasswordStates> {
  ForgotPasswordController() : super(ForgotPasswordStates());

  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(timerCount: 60);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerCount > 0) {
        state = state.copyWith(timerCount: state.timerCount - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  void toggleForgotPassword(bool value) {
    state = state.copyWith(isForgotPassword: value, stepIndex: 0);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email, stepIndex: 1);
  }

  void setOtpCode(int code) {
    state = state.copyWith(otpCode: code, stepIndex: 2);
  }

  void resendOtp() {
    if (state.timerCount == 0) {
      state = state.copyWith(resendOtpCount: state.resendOtpCount + 1);
      startTimer();
    }
  }

  void previousStep() {
    if (state.stepIndex > 0) {
      state = state.copyWith(stepIndex: state.stepIndex - 1);
    } else {
      state = state.copyWith(isForgotPassword: false);
    }
  }

  void reset() {
    state = ForgotPasswordStates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordStates>((
      ref,
    ) {
      return ForgotPasswordController();
    });
