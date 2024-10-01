import 'package:flutter/material.dart';
import 'package:myapp/routes/routes.dart';
import 'package:myapp/views/auths/login_page.dart';
// import 'package:myapp/views/pages/onboarding_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPEG ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      initialRoute: '/', // Set the initial route
      routes: Routes.getRoutes(), // Use the routes from routes.dart
    );
  }
}
