import 'package:flutter/material.dart';
import 'package:myapp/views/auths/auth_gate.dart';
import 'package:myapp/views/auths/login_page.dart';
import 'package:myapp/views/auths/register_page.dart';
import 'package:myapp/views/pages/arrival_data.dart';
import 'package:myapp/views/pages/existing_batch_page.dart';
import 'package:myapp/views/pages/get_started_page.dart';
import 'package:myapp/views/pages/new_batch.dart';
import 'package:myapp/views/pages/onboarding_page.dart';
import 'package:myapp/views/pages/profile_page.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const GetStartedPage(),
      '/auth': (context) => const AuthPage(),
      '/onboarding': (context) => const OnboardingPage(),
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/profile': (context) => ProfilePage(),
      '/newBatch': (context) => const NewBatchPage(),
      '/existBatches': (context) => BatchesPage(),
      '/arrivalData': (context) => const ArrivalDataPage(),

      // Add other routes here
    };
  }
}
