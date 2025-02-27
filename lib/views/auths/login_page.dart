import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/auth_services.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_textfield.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.onTap});
  final Function()? onTap;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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

          Center(
            // Use Center widget to ensure all content stays centered
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 600 : screenWidth * 0.9,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30), // Gap at the top

                      // Welcome back text
                      Text(
                        "Welcome Back",
                        style: AppConstants.titleTextStyle
                            .copyWith(color: Colors.white, fontSize: 34),
                      ),
                      const Gap(10),

                      // Sign in text
                      const Text(
                        "Enter your email address to get \naccess to your account.",
                        textAlign: TextAlign.center,
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
                        obsecureText: false,
                      ),
                      const Gap(20),

                      // Password field
                      MyTextForm(
                        hintText: "Password",
                        prefix: const Icon(Icons.lock),
                        controller: passwordController,
                        obsecureText: true,
                      ),

                      // Forgot password text
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 10),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Text(
                      //         "Forgot Password?",
                      //         style: AppConstants.subtitleTextStyle
                      //             .copyWith(color: Colors.blue, fontSize: 13),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const Gap(30),

                      // Login button
                      GestureDetector(
                        onTap: () async {
                          try {
                            await ref
                                .read(authServiceProvider)
                                .signInWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text,
                                    context);
                          } catch (e) {
                            // Show an error message if login fails
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
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
                                offset: const Offset(0, 3),
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

                      const Gap(30),

                      // Don't have an account text
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "Don't have an account?",
                      //       style: AppConstants.subtitleTextStyle
                      //           .copyWith(color: Colors.white, fontSize: 13),
                      //     ),
                      //     const Gap(5),
                      //     GestureDetector(
                      //       onTap: widget.onTap,
                      //       child: Text(
                      //         "Create an account.",
                      //         style: AppConstants.subtitleTextStyle
                      //             .copyWith(color: Colors.blue, fontSize: 13),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const Gap(30),

                      // Divider with "Or Sign In with"
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
                              "Got a Problem",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 13),
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

                      // Text
                      const Gap(20),

                      const Text(
                        "Incase you have a problem with your account, please contact us 0500159892",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Product Sans Regular",
                            fontSize: 13),
                      ),

                      // Image.asset("assets/images/goog.png"),
                      // const Gap(20),

                      // const Text(
                      //   "Terms of Services\nPrivacy of Policy",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontFamily: "Product Sans Regular",
                      //       fontSize: 10),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}