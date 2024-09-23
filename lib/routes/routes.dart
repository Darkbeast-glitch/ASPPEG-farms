import 'package:flutter/material.dart';
import 'package:myapp/views/pages/get_started_page.dart';
import 'package:myapp/views/pages/onboarding_page.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/getstarted': (context) => const GetStartedPage(),
      '/onboarding': (context) => const OnboardingPage(),

      // Add other routes here
    };
  }
}
