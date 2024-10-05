import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/auth_services.dart';
import 'package:myapp/utils/my_buttons.dart';
import 'package:myapp/views/auths/login_or_register.dart';

// // Suggested code may be subject to a license. Learn more: ~LicenseLog:648999709.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3130495941.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1448934804.

class ProfilePage extends ConsumerWidget {
  ProfilePage({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAuthProvider = ref.read(authSerivceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // align center
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // circle avatar to show a default avatar image
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/fly.jpg'), // Replace with actual image
            ),
            const SizedBox(height: 20),

            // display user name and email

            Text(
              '${userAuthProvider.currentUser?.email ?? 'User Name'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${userAuthProvider.currentUser?.email ?? 'Email Address'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            MyButton(
              onTap: () async {
                await userAuthProvider.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginOrRegisterPage(),
                  ),
                );
              },
              text: "Sign Out",
            ),
          ],
        ),
      ),
    );
  }
}
