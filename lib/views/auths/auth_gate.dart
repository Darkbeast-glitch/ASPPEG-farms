import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/views/auths/login_or_register.dart';
import 'package:myapp/views/pages/onboarding_page.dart';
import 'package:myapp/views/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Future<bool> _hasViewedOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasViewedOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _hasViewedOnboarding(),
        builder: (context, onboardingSnapshot) {
          if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If onboarding is not completed, show onboarding page
          if (onboardingSnapshot.data == false) {
            return const OnboardingPage();
          }

          // Otherwise, check if the user is logged in or not
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // If logged in, go to the home page
              if (snapshot.hasData) {
                return const HomePage();
              }

              // If not logged in, go to the login page
              return const LoginOrRegisterPage();
            },
          );
        },
      ),
    );
  }
}
