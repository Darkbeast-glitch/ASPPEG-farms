import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import riverpod
import 'package:myapp/services/auth_services.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_textfield.dart';

class LoginPage extends ConsumerWidget {
  // Change to ConsumerWidget
  const LoginPage({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ConsumerWidget uses WidgetRef
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Background image with a darker overlay
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7), // Darken the image
              BlendMode.darken,
            ),
            child: Image.asset(
              'assets/images/farm.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // Subtle blur
            child: Container(
              color: Colors.black.withOpacity(0), // Transparent overlay
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Center(
                // Center the content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30), // Gap at the top

                    // a welcome back text
                    Text(
                      "Welcome Back",
                      style: AppConstants.titleTextStyle
                          .copyWith(color: Colors.white, fontSize: 34),
                    ),
                    // a sign in text
                    const Text(
                      textAlign: TextAlign.center,
                      "Enter your email address to get \naccess to your account.",
                      style: TextStyle(
                          fontFamily: "Product Sans Regular",
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w300),
                    ),
                    const Gap(50),

                    MyTextForm(
                        hintText: "Username or Email",
                        prefix: const Icon(Icons.email),
                        controller: emailController,
                        obsecureText: false),
                    const Gap(20),

                    // a password field
                    MyTextForm(
                        hintText: "Password",
                        prefix: const Icon(Icons.lock),
                        controller: passwordController,
                        obsecureText: true),
                    const Gap(10),

                    // a forget password
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // a text that says forget password?
                          Text(
                            "Forgot Password?",
                            style: AppConstants.subtitleTextStyle
                                .copyWith(color: Colors.blue, fontSize: 13),
                          )
                        ],
                      ),
                    ),
                    const Gap(30),

                    // a login in button
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(authSerivceProvider)
                            .signInWithEmailAndPassword(emailController.text,
                                passwordController.text, context);
                      },
                      child: Container(
                        height: 47,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: "Product Sans Regular",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),

                    // don't have an account text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: AppConstants.subtitleTextStyle
                              .copyWith(color: Colors.white, fontSize: 13),
                        ),
                        const Gap(5),
                        GestureDetector(
                          onTap:
                              onTap, // No need for widget.onTap in ConsumerWidget
                          child: Text(
                            "Create an account.",
                            style: AppConstants.subtitleTextStyle
                                .copyWith(color: Colors.blue, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const Gap(30),

                    // Dividers in a row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Or Sign In with",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),

                    Image.asset("assets/images/goog.png"),
                    const Gap(20),

                    const Text(
                      textAlign: TextAlign.center,
                      "Terms of Services\nPrivacy of Policy",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Product Sans Regular",
                          fontSize: 10),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
