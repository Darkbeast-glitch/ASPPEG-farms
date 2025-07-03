import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/views/auths/login_page.dart';

final authServiceProvider = Provider<AuthService>((ref) {
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

      // Navigate to the home page
      Navigator.of(context).pushReplacementNamed('/home');
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
    await googleSignIn.signOut(); // Also sign out from Google if logged in with Google

    // Navigate to the login page
    navigatorKey.currentState?.pushReplacementNamed('/login');
  }

  Future<void> signUpWithEmailAndPassword(
      String name, String email, String password, BuildContext context) async {
    try {
      if (navigatorKey.currentContext != null) {
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      // Sign up the user
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String firebaseUID = userCredential.user?.uid ?? '';
      final apiService = ref.read(apiServiceProvider);
      bool isUserSaved =
          await apiService.saveUserToBackend(name, email, firebaseUID);

      if (navigatorKey.currentState?.canPop() == true) {
        navigatorKey.currentState?.pop();
      }

      if (!context.mounted) return;

      if (isUserSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Account created successfully, proceed to login!'),
          ),
        );

        // Logout user (if necessary)
        await auth.signOut();

        // Navigate to the Login page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content:
                Text('Failed to save user data to backend. Please try again.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (navigatorKey.currentState?.canPop() == true) {
        navigatorKey.currentState?.pop();
      }

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

  // Method to get the current logged in user
  User? getCurrentUser() {
    return auth.currentUser;
  }
}