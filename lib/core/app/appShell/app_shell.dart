import 'package:e_tantana/core/app/initialiser/app_initiliser.dart';
import 'package:e_tantana/core/mainErrorListener/success_error_listener.dart';
import 'package:e_tantana/core/app/session/session_controller.dart';
import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/auth/presentation/pages/onboarding_page.dart';
import 'package:e_tantana/features/auth/presentation/pages/sign_in.dart';
import 'package:e_tantana/features/auth/presentation/states/auth_states.dart';
import 'package:e_tantana/features/nav_bar/presentation/nav_bar.dart';
import 'package:e_tantana/features/splashView/presentation/pages/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(appInitializerProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(sessionProvider);
    final authState = ref.watch(authControllerProvider);

    return SuccessErrorListener(child: _buildScreen(authState.status));
  }

  Widget _buildScreen(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        return const NavBar();
      case AuthStatus.unauthenticated:
        return const SignIn();
      case AuthStatus.onboarding:
        return const OnboardingPage();
      default:
        return const SplashView();
    }
  }
}
