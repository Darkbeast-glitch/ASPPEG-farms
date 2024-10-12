import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/views/auths/login_page.dart';

final authSerivceProvider = Provider<AuthService>((ref) {
  return AuthService(
      auth: FirebaseAuth.instance, googleSignIn: GoogleSignIn(), ref: ref);
});
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AuthService {
  FirebaseAuth auth;
  GoogleSignIn googleSignIn;
  final Ref ref;

  AuthService(
      {required this.auth, required this.googleSignIn, required this.ref});

  get currentUser => auth.currentUser;

  // Sign in with Google function
  Future<void> signInWithGoogle() async {
    final user = await googleSignIn.signIn();
    final googleAuth = await user!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await auth.signInWithCredential(credential);

    // Print the Firebase ID token to the console
    await printFirebaseToken();
  }

  // Sign in with email and password method
  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);

      // Print the Firebase ID token to the console
      await printFirebaseToken();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // Handle errors
      print(e.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  // Method to get and print Firebase ID Token for the current user
  Future<void> printFirebaseToken() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken();
        print('Firebase ID Token: $idToken');
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error getting Firebase ID Token: $e');
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> signUpWithEmailAndPassword(
      String name, String email, String password, BuildContext context) async {
    try {
      // Show loading indicator using the navigatorKey context
      if (navigatorKey.currentContext != null) {
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      // Sign up the user using Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Get Firebase UID of the newly created user
      String firebaseUID = userCredential.user?.uid ?? '';

      // Use the ApiService provider to save user data to the backend
      final apiService = ref.read(apiServiceProvider);
      bool isUserSaved =
          await apiService.saveUserToBackend(name, email, firebaseUID);

      // Safely close the dialog using the navigatorKey context
      if (navigatorKey.currentState?.canPop() == true) {
        navigatorKey.currentState?.pop();
      }

      // Check if the current widget is still mounted before navigating
      if (!context.mounted) return;

      if (isUserSaved) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Account created successfully, proceed to login!'),
          ),
        );

        // Navigate to the Login page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        ); // Ensure this is the correct route
      } else {
        // Show error message if saving user data failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content:
                Text('Failed to save user data to backend. Please try again.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Safely close the dialog using the navigatorKey context
      if (navigatorKey.currentState?.canPop() == true) {
        navigatorKey.currentState?.pop();
      }

      // Handle errors and show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text(e.message ?? 'An error occurred during registration.'),
          ),
        );
      }
    }
  }

  Future<String?> getIdToken() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken();
        print('Firebase ID Token: $idToken');
        return idToken;
      } else {
        print('No user is currently signed in.');
        return null;
      }
    } catch (e) {
      print('Error getting Firebase ID Token: $e');
      return null;
    }
  }
}
