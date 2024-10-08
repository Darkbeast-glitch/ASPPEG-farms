import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authSerivceProvider = Provider<AuthService>((ref) {
  return AuthService(auth: FirebaseAuth.instance, googleSignIn: GoogleSignIn());
});

class AuthService {
  FirebaseAuth auth;
  GoogleSignIn googleSignIn;

  AuthService({
    required this.auth,
    required this.googleSignIn,
  });

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

  // Method to sign up users
  Future<void> signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Sign up the user
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Dismiss the loading indicator
      Navigator.pop(context);

      // Navigate to the GetStarted page
      Navigator.pushReplacementNamed(context, '/getStarted');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Account created successfully!'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Dismiss the loading indicator
      Navigator.pop(context);

      // Handle errors and show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.message!),
        ),
      );

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
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

