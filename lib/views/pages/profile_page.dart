import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/auth_services.dart';
import 'package:myapp/utils/my_buttons.dart';
import 'package:myapp/views/auths/auth_gate.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAuthProvider = ref.read(authSerivceProvider);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circle avatar for user profile
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/fly.jpg'), // Replace with actual image
            ),
            const SizedBox(height: 20),

            // Display user email
            Text(
              user?.email ?? 'User Email',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Display user UID or any other info
            Text(
              user?.uid ?? 'User ID',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Sign out button
            MyButton(
              onTap: () async {
                try {
                  await userAuthProvider.signOut();
                  // Navigate back to login screen after sign out
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AuthPage(),
                    ),
                  );
                } catch (e) {
                  // Handle sign out error if necessary
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              },
              text: "Sign Out",
            ),
          ],
        ),
      ),
    );
  }
}
