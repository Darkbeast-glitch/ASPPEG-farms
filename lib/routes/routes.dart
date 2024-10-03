import 'package:flutter/material.dart';
import 'package:myapp/views/auths/auth_gate.dart';
import 'package:myapp/views/auths/login_page.dart';
import 'package:myapp/views/auths/register_page.dart';
import 'package:myapp/views/pages/get_started_page.dart';
import 'package:myapp/views/pages/onboarding_page.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const AuthPage(),
      '/getstarted': (context) => const GetStartedPage(),
      '/onboarding': (context) => const OnboardingPage(),
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),

      // Add other routes here
    };
  }
}
