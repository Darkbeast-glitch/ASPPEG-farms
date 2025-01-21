import 'package:flutter/material.dart';
import 'package:myapp/views/auths/auth_gate.dart';
import 'package:myapp/views/auths/login_page.dart';
import 'package:myapp/views/auths/register_page.dart';
import 'package:myapp/views/pages/batch_select.dart';
import 'package:myapp/views/pages/field_details_first_repro.dart';
import 'package:myapp/views/pages/first_acclimatization_page.dart';
import 'package:myapp/views/pages/arrival_data.dart';
import 'package:myapp/views/pages/existing_batch_page.dart';
import 'package:myapp/views/pages/first_cut_page.dart';
import 'package:myapp/views/pages/first_reproudction_area.dart';
import 'package:myapp/views/pages/get_started_page.dart';
import 'package:myapp/views/pages/green_house.dart';
import 'package:myapp/views/pages/home_page.dart';
import 'package:myapp/views/pages/new_batch.dart';
import 'package:myapp/views/pages/onboarding_page.dart';
import 'package:myapp/views/pages/profile_page.dart';
import 'package:myapp/views/pages/second_acclimatizaton_page.dart';
import 'package:myapp/views/pages/variety_data.dart';

import '../views/pages/new_fd_first_repro.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const GetStartedPage(),
      '/auth': (context) => const AuthPage(),
      '/home': (context) => const HomePage(),
      '/onboarding': (context) => const OnboardingPage(),
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/profile': (context) => const ProfilePage(),
      '/newBatch': (context) => const NewBatchScreen(),
      '/existBatches': (context) => const BatchesPage(),
      '/arrivalData': (context) => const ArrivalDataPage(),
      '/varietyData': (context) => const VarietyDetailsPage(),
      '/addAcclimatization': (context) => const AcclimatizationPage(),
      '/secondAcclimatization': (context) => const SecondAcclimatizationPage(),
      '/greenHouse': (context) => const GreenhousePage(),
      '/firstCut': (context) => const FirstCutPage(),
      '/secondCut': (context) => const FirstCutPage(),
      '/batchSelect': (context) => const BatchSelectionPage(),
      // '/fieldDetails': (context) => const FieldDetailsPage(),
      '/fieldDetails': (context) => const NewFieldDetailsPage(),
      '/firstReproduction': (context) => const FirstReproudctionArea(),
      '/secondReproduction': (context) => const SecondAcclimatizationPage(),


      // Add other routes here
    };
  }
}
