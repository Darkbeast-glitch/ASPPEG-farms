import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/routes/routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e) {
    // Handle Firebase initialization errors
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPEG ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey, // This allows for global navigation
      initialRoute: '/', // Set the initial route
      routes: Routes.getRoutes(), // Use the routes from routes.dart
    );
  }
}
