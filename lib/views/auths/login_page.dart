import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:ui';

import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // a welcome back text
                Text(
                  "Welcome Back",
                  style: AppConstants.titleTextStyle
                      .copyWith(color: Colors.white, fontSize: 34),
                ),
                // a sign in text
                Text(
                  "Enter your email address to get access to your account",
                  style: AppConstants.seconTitleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w300),
                ),
                const Gap(60),
                MyTextForm(
                    hintText: "Username or Email",
                    prefix: const Icon(Icons.email),
                    controller: _emailController,
                    obsecureText: false),
                const Gap(30),

                // a password field
                MyTextForm(
                    hintText: "Password",
                    prefix: const Icon(Icons.lock),
                    controller: _passwordController,
                    obsecureText: true),
                const Gap(5),

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
                Container(
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
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

                // don't have an account text
              ],
            ),
          ),
        ],
      ),
    );
  }
}
